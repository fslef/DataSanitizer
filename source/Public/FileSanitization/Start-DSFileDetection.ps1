function Start-DSFileDetection {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [PsfDirectory]$InputPath = (Get-PSFConfig -Module DataSanitizer -Name 'Path.DSLogInputFolder')
    )

    process {

        Write-PSFMessage -Module DataSanitizer -Level Important -String 'Start-DSFileDetection.Start' -StringValues $InputPath

        Write-PSFMessage -Module DataSanitizer -Level Verbose -String 'Start-DSFileDetection.StartingFile' -StringValues $InputPath

        Show-Disclaimer

        #region ZIP Processing
        # Check for ZIP files in the folder (and subfolders) and extract them
        $zipFiles = Get-ChildItem -Path $InputPath -Recurse -Filter "*.zip" -File
        if ($zipFiles.Count -gt 0) {
            Write-PSFMessage -Module DataSanitizer -Level Verbose -String 'Start-DSFileDetection.ZipFilesFound' -StringValues $zipFiles.Count

            foreach ($zipFile in $zipFiles) {
                # Extract ZIP file directly into the same directory as the ZIP file (not into a subfolder)
                $extractionPath = $zipFile.DirectoryName

                Write-PSFMessage -Module DataSanitizer -Level Verbose -String 'Start-DSFileDetection.UnarchivingZip' -StringValues $zipFile.FullName, $extractionPath
                Expand-Archive -Path $zipFile.FullName -DestinationPath $extractionPath -Force
                Remove-Item -Path $zipFile.FullName -Force
                Write-PSFMessage -Module DataSanitizer -Level Verbose -String 'Start-DSFileDetection.ZipUnarchived' -StringValues $extractionPath
            }
        }
        #endregion ZIP Processing

        #region File Inventory
        # Do File Inventory
        Write-PSFMessage -Module DataSanitizer -Level Important -String 'Start-DSFileDetection.StartInventory' -StringValues $InputPath

        $FileList = Get-ChildItem -Path $InputPath -Recurse -File

        foreach ($file in $FileList | ConvertTo-PSFHashtable -ReferenceCommand Add-ToFileInventory) {
            Add-ToFileInventory @file
        }

        $script:FileInventoryArray = @()
        foreach ($filePath in $script:FileInventory.Keys) {
            $meta = $script:FileInventory[$filePath]
            $script:FileInventoryArray += [pscustomobject]@{
                Path                = $filePath
                Name                = $meta.Name
                ResolvedTarget      = $meta.ResolvedTarget
                Extension           = $meta.Extension
                Size                = $meta.Size
                AnonymizationStatus = $meta.AnonymizationStatus
                IsValid             = $meta.IsValid
                Findings            = $meta.Findings
            }
        }

        # Export the inventory to a JSON file in the _Config folder
        $RootFolder = (Get-PSFConfig -Module DataSanitizer -Name 'Path.DSrootFolder').value
        $ConfigFolderPath = Join-Path -Path $RootFolder -ChildPath "_Config"
        $script:FileInventoryArray | Export-PSFJson -Path (Join-Path -Path $ConfigFolderPath -ChildPath "FileInventory.json")

        # Summarize the inventory
        $totalFiles = $script:FileInventoryArray.Count
        $totalSize = ($script:FileInventoryArray | Measure-Object -Property Size -Sum).Sum
        $validFiles = $script:FileInventoryArray | Where-Object { $_.IsValid }
        $invalidFiles = $script:FileInventoryArray | Where-Object { -not $_.IsValid }
        $validCount = $validFiles.Count
        $invalidCount = $invalidFiles.Count
        $validSize = ($validFiles | ForEach-Object { [long]$_.Size } | Measure-Object -Sum).Sum
        $invalidSize = ($invalidFiles | ForEach-Object { [long]$_.Size } | Measure-Object -Sum).Sum

        Write-PSFMessage -Module DataSanitizer -Level Significant -String 'Start-DSFileDetection.InventorySummary' -StringValues $totalFiles, (Format-DSSize -Bytes $totalSize)
        Write-PSFMessage -Module DataSanitizer -Level Significant -String 'Start-DSFileDetection.InventoryValidity' -StringValues $validCount, (Format-DSSize -Bytes $validSize), $invalidCount, (Format-DSSize -Bytes $invalidSize)

        Write-PSFMessage -Module DataSanitizer -Level Verbose -String 'Start-DSFileDetection.InventoryByExtHeader'
        $grouped = $validFiles | Group-Object -Property Extension | Sort-Object Count -Descending
        foreach ($g in $grouped) {
            $extSize = ($g.Group | ForEach-Object { [long]$_.Size } | Measure-Object -Sum).Sum
            Write-PSFMessage -Module DataSanitizer -Level Verbose -String 'Start-DSFileDetection.InventoryByExtItem' -StringValues $g.Name, $g.Count, (Format-DSSize -Bytes $extSize)
        }
        #endregion File Inventory

    }
}
