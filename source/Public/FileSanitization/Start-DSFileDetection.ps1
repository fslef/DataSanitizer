function Start-DSFileDetection {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [PsfDirectory]$InputPath = (Get-PSFConfig -Module DataSanitizer -Name 'Path.DSLogInputFolder')
    )

    process {

        Write-PSFMessage -Module DataSanitizer -Level Important -String 'Start-DSFileDetection.Start' -StringValues $InputPath

        # Determine if the path is a file or a directory
        if (Test-Path -Path $InputPath -PathType Container) {
            Write-PSFMessage -Module DataSanitizer -Level Verbose -String 'Start-DSFileDetection.StartingFolder' -StringValues $InputPath
            # NOTE : Code for a folder input path
        }
        else {
            Write-PSFMessage -Module DataSanitizer -Level Verbose -String 'Start-DSFileDetection.StartingFile' -StringValues $InputPath
            # NOTE : Code for a file input path

            # If Zip file, extract it to the current folder and remove the zip file. Loop on each zip file in the extracted folder
            if ($InputPath -like '*.zip') {
                # Extract ZIP file to a folder named after the ZIP (without extension), then recursively process each extracted file
                $zipName = [System.IO.Path]::GetFileNameWithoutExtension($InputPath)
                $inputDir = (Get-Item $InputPath).DirectoryName
                $extractedFolder = [System.IO.Path]::Combine($inputDir, $zipName)

                Write-PSFMessage -Module DataSanitizer -Level Verbose -String 'Start-DSFileDetection.UnarchivingZip' -StringValues $InputPath, $extractedFolder
                Expand-Archive -Path $InputPath -DestinationPath $extractedFolder -Force
                Remove-Item -Path $InputPath -Force
                Write-PSFMessage -Module DataSanitizer -Level Verbose -String 'Start-DSFileDetection.ZipUnarchived' -StringValues $extractedFolder

                # Update InputPath to the extracted folder for subsequent processing
                $InputPath = $extractedFolder
            }
            else {
                # Process the file (e.g., scan for sensitive data)
                Write-PSFMessage -Module DataSanitizer -Level Verbose -String 'Start-DSFileDetection.ProcessingFile' -StringValues $InputPath
                # NOTE : Add code to process the file here
                # For single files, we need to process just that file, not recurse
                return
            }

        }

        # Do File Inventory
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

        # TODO Change Path
        $script:FileInventoryArray | Export-PSFJson -Path "/Users/francoislefebvre/gitrepos/fslef/dataSanitizer/.automatedlab/DS-RootFolder/_Config/FileInventory.json"

        $totalFiles = $script:FileInventoryArray.Count
        $totalSize = ($script:FileInventoryArray | Measure-Object -Property Size -Sum).Sum
        $validFiles = $script:FileInventoryArray | Where-Object { $_.IsValid }
        $invalidFiles = $script:FileInventoryArray | Where-Object { -not $_.IsValid }
        $validCount = $validFiles.Count
        $invalidCount = $invalidFiles.Count
        $validSize = ($validFiles | Measure-Object -Property Size -Sum).Sum
        $invalidSize = ($invalidFiles | Measure-Object -Property Size -Sum).Sum

        Write-PSFMessage -Module DataSanitizer -Level Significant -String 'Start-DSFileDetection.InventorySummary' -StringValues $totalFiles, (Format-DSSize -Bytes $totalSize)
        Write-PSFMessage -Module DataSanitizer -Level Significant -String 'Start-DSFileDetection.InventoryValidity' -StringValues $validCount, (Format-DSSize -Bytes $validSize), $invalidCount, (Format-DSSize -Bytes $invalidSize)

        Write-PSFMessage -Module DataSanitizer -Level Verbose -String 'Start-DSFileDetection.InventoryByExtHeader'
        $grouped = $validFiles | Group-Object -Property Extension | Sort-Object Count -Descending
        foreach ($g in $grouped) {
            $extSize = ($g.Group | Measure-Object -Property Size -Sum).Sum
            Write-PSFMessage -Module DataSanitizer -Level Verbose -String 'Start-DSFileDetection.InventoryByExtItem' -StringValues $g.Name, $g.Count, (Format-DSSize -Bytes $extSize)
        }

    }
}
