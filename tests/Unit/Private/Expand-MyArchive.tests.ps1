BeforeAll {
    . "$PSScriptRoot/../../source/Private/Expand-MyArchive.ps1"
    Mock Write-OutputPadded {}
    Mock New-Folder {}
    Mock Expand-Archive {}
}

Describe 'Expand-MyArchive' {
    $archive = Join-Path $env:TEMP ("TestArchive_" + [guid]::NewGuid() + ".zip")
    $dest = Join-Path $env:TEMP ("Extracted_" + [guid]::NewGuid())
    $logFile = Join-Path $env:TEMP ("TestLog_" + [guid]::NewGuid() + ".log")

    Context 'When archive does not exist' {
        It 'Should throw and log error' {
            { Expand-MyArchive -ArchivePath $archive -DestinationPath $dest -LogFile $logFile } | Should -Throw -ErrorMessage "Archive file not found*"
        }
    }

    Context 'When archive exists' {
        BeforeEach {
            Set-Content -Path $archive -Value 'dummy' -Force
            if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
        }
        AfterEach {
            if (Test-Path $archive) { Remove-Item $archive -Force }
            if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
        }
        It 'Should call Expand-Archive and New-Folder' {
            Expand-MyArchive -ArchivePath $archive -DestinationPath $dest -LogFile $logFile
            Should -Invoke Expand-Archive
            Should -Invoke New-Folder
        }
    }

    Context 'When Overwrite is specified and destination exists' {
        BeforeEach {
            Set-Content -Path $archive -Value 'dummy' -Force
            New-Item -ItemType Directory -Path $dest | Out-Null
        }
        AfterEach {
            if (Test-Path $archive) { Remove-Item $archive -Force }
            if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
        }
        It 'Should remove destination and extract' {
            Expand-MyArchive -ArchivePath $archive -DestinationPath $dest -Overwrite -LogFile $logFile
            Should -Invoke Expand-Archive
            Should -Invoke New-Folder
        }
    }
}
