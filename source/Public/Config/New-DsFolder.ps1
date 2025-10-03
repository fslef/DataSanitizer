function New-DsFolder {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [PsfDirectorySingle]$RootFolder,

        [String]$IntermediateFolderName
    )

    begin {
        Initialize-DSModuleSession
    }

    process {

        Write-PSFMessage -Module DataSanitizer -Level Important -String 'New-DsFolder.Start' -StringValues $RootFolder

        # Check the folder is empty, break if not
        if ((Get-ChildItem -Path $RootFolder -Recurse | Measure-Object).Count -gt 0) {
            throw "CANCELED The target folder is not empty. Please provide an empty folder."
        }

        # Preparing the folders

        # Adding _Config Folder under root
        Write-PSFMessage -Module DataSanitizer -Level Verbose -String 'New-DsFolder.AddingConfigFolder' -StringValues $RootFolder
        New-Item -Path $RootFolder -Name "_Config" -ItemType Directory | Out-Null
        [PsfDirectorySingle] $ConfigFolderPath = Join-Path -Path $RootFolder -ChildPath "_Config"

        # Add _Intermediate Folder
        if ($IntermediateFolderName) {
            Write-PSFMessage -Module DataSanitizer -Level Verbose -String 'New-DsFolder.AddingIntermediateFolder' -StringValues $IntermediateFolderName, $RootFolder
            New-Item -Path $RootFolder -Name $IntermediateFolderName -ItemType Directory | Out-Null
            [PsfDirectorySingle] $IntermediateFolderPath = Join-Path -Path $RootFolder -ChildPath $IntermediateFolderName

        }

        # Adding First Log Folderimport
        if ($IntermediateFolderName) {
            Write-PSFMessage -Module DataSanitizer -Level Verbose -String 'New-DsFolder.AddingLogFolder' -StringValues $IntermediateFolderPath
            New-Item -Path $IntermediateFolderPath -Name "LogFolder" -ItemType Directory | Out-Null
            [PsfDirectorySingle] $LogFolderPath = Join-Path -Path $IntermediateFolderPath -ChildPath "LogFolder"

        }
        else {
            Write-PSFMessage -Module DataSanitizer -Level Verbose -String 'New-DsFolder.AddingLogFolder' -StringValues $RootFolder
            New-Item -Path $RootFolder -Name "LogFolder" -ItemType Directory | Out-Null
            [PsfDirectorySingle] $LogFolderPath = Join-Path -Path $RootFolder -ChildPath "LogFolder"

        }
        # Adding Input Folder under LogFolder
        Write-PSFMessage -Module DataSanitizer -Level Verbose -String 'New-DsFolder.AddingLogInputFolder' -StringValues $LogFolderPath
        New-Item -Path $LogFolderPath -Name "Input" -ItemType Directory | Out-Null
        [PsfDirectorySingle] $LogInputFolderPath = Join-Path -Path $LogFolderPath -ChildPath "Input"


        # Adding working Folder under LogFolder
        Write-PSFMessage -Module DataSanitizer -Level Verbose -String 'New-DsFolder.AddingLogWorkingFolder' -StringValues $LogFolderPath
        New-Item -Path $LogFolderPath -Name "WorkingFolder" -ItemType Directory | Out-Null
        [PsfDirectorySingle] $LogWorkingFolderPath = Join-Path -Path $LogFolderPath -ChildPath "WorkingFolder"

        # Adding Json config File

        $config = [PSCustomObject]@{
            Version = 1
            Static  = [PSCustomObject]@{
                "DataSanitizer.path.DSrootFolder"     = $RootFolder.path
                "DataSanitizer.path.DSLogInputFolder" = $LogInputFolderPath.path
            }
        }

        # Export to JSON using PSFramework
        Write-PSFMessage -Module DataSanitizer -Level Host -String 'New-DsFolder.AddingConfigFile' -StringValues $RootFolder
        $configPath = Join-Path -Path $ConfigFolderPath -ChildPath "DataSanitizer.cfg.json"
        Export-PSFJson -InputObject $config -Path $configPath -Depth 10


        Set-PSFConfig -Module DataSanitizer -Name 'Path.DSrootFolder' -Value $RootFolder
        Set-PSFConfig -Module DataSanitizer -Name 'Path.DSConfigFile' -Value (Join-Path -Path $ConfigFolderPath -ChildPath "DataSanitizer.cfg.json")

        # Create a baseline DetectionRules.cfg.json file
        Write-PSFMessage -Module DataSanitizer -Level Host -String 'New-DsFolder.AddingDetectionRulesFile' -StringValues $ConfigFolderPath
        New-DSDetectionConfig -Path (Join-Path -Path $ConfigFolderPath -ChildPath "DetectionRules.cfg.json") -IncludeBaseline
    }
}
