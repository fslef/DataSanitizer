function Initialize-DsFolder {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [PsfDirectory]$RootFolder,

        [String]$IntermediateFolderName
    )

    begin {
        Initialize-DSModuleSession
    }

    process {

        Write-PSFMessage -Module DataSanitizer -Level Important -String 'Initialize-DsFolder.Start' -StringValues $RootFolder

        # Check the folder is empty, break if not
        if ((Get-ChildItem -Path $RootFolder -Recurse | Measure-Object).Count -gt 0) {
            throw "CANCELED The target folder is not empty. Please provide an empty folder."
        }

        # Preparing the folders

        # Adding _Config Folder under root
        Write-PSFMessage -Module DataSanitizer -Level Verbose -String 'Initialize-DsFolder.AddingConfigFolder' -StringValues $RootFolder
        New-Item -Path $RootFolder -Name "_Config" -ItemType Directory | Out-Null

        [PsfDirectory] $ConfigFolderPath = Join-Path -Path $RootFolder -ChildPath "_Config"

        # Add _Intermediate Folder
        if ($IntermediateFolderName) {
            Write-PSFMessage -Module DataSanitizer -Level Verbose -String 'Initialize-DsFolder.AddingIntermediateFolder' -StringValues $IntermediateFolderName, $RootFolder

            New-Item -Path $RootFolder -Name $IntermediateFolderName -ItemType Directory | Out-Null

            [PsfDirectory] $IntermediateFolderPath = Join-Path -Path $RootFolder -ChildPath $IntermediateFolderName

        }

        # Adding First Log Folderimport
        if ($IntermediateFolderName) {
            Write-PSFMessage -Module DataSanitizer -Level Verbose -String 'Initialize-DsFolder.AddingLogFolder' -StringValues $IntermediateFolderPath

            New-Item -Path $IntermediateFolderPath -Name "LogFolder" -ItemType Directory | Out-Null

            [PsfDirectory] $LogFolderPath = Join-Path -Path $IntermediateFolderPath -ChildPath "LogFolder"

            Set-PSFConfig -Module DataSanitizer -Name 'Path.DSLogFolder' -Value $LogFolderPath # -Validation string -Initialize -Description "The Log folder for DataSanitizer."
        }
        else {
            Write-PSFMessage -Module DataSanitizer -Level Verbose -String 'Initialize-DsFolder.AddingLogFolder' -StringValues $RootFolder

            New-Item -Path $RootFolder -Name "LogFolder" -ItemType Directory | Out-Null

            [PsfDirectory] $LogFolderPath = Join-Path -Path $RootFolder -ChildPath "LogFolder"

            Set-PSFConfig -Module DataSanitizer -Name 'Path.DSLogFolder' -Value $LogFolderPath # -Validation string -Initialize -Description "The Log folder for DataSanitizer."
        }

        # Adding Json config File

        $config = [PSCustomObject]@{
            Version = 1
            Static  = [PSCustomObject]@{
                "DataSanitizer.path.DSrootFolder" = $RootFolder
                "DataSanitizer.path.DSLogFolder"  = $LogFolderPath
            }
        }

        # Export to JSON using PSFramework
        Write-PSFMessage -Module DataSanitizer -Level Host -String 'Initialize-DsFolder.AddingConfigFile' -StringValues $RootFolder
        Export-PSFJson -InputObject $config -Path (Join-Path -Path $ConfigFolderPath -ChildPath "DataSanitizer.cfg.json") -Depth 10

        Set-PSFConfig -Module DataSanitizer -Name 'Path.DSrootFolder' -Value $RootFolder
        Set-PSFConfig -Module DataSanitizer -Name 'Path.DSConfigFile' -Value (Join-Path -Path $ConfigFolderPath -ChildPath "DataSanitizer.cfg.json")

        # Create a baseline DetectionRules.cfg.json file
        Write-PSFMessage -Module DataSanitizer -Level Host -String 'Initialize-DsFolder.AddingDetectionRulesFile' -StringValues $ConfigFolderPath
        New-DSDetectionConfig -Path (Join-Path -Path $ConfigFolderPath -ChildPath "DetectionRules.cfg.json") -IncludeBaseline
    }
}
