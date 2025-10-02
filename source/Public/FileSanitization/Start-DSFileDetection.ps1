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

        # Convert hashtable to array format for JSON export
        $script:FileInventoryArray = @()
        foreach ($filePath in $script:FileInventory.Keys) {
            $fileObject = @{}
            $fileObject[$filePath] = $script:FileInventory[$filePath]
            $script:FileInventoryArray += $fileObject
        }

        # TODO Change Path
        $script:FileInventoryArray | Export-PSFJson -Path "/Users/francoislefebvre/gitrepos/fslef/dataSanitizer/.automatedlab/DS-RootFolder/_Config/FileInventory.json"

        Write-Output "File Inventory Hashtable Count: $($script:FileInventory.Count)"
        Write-Output "File Inventory Array Count: $($script:FileInventoryArray.Count)"

    }
}
