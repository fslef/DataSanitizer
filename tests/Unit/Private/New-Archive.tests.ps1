BeforeAll {
    . "$PSScriptRoot/../../source/Private/New-Archive.ps1"
    Mock Write-OutputPadded {}
    Mock Remove-Item {}
    Mock Move-Item {}
    Mock Add-Type {}
}

Describe 'New-Archive' {
    $srcFile = Join-Path $env:TEMP ("TestFile_" + [guid]::NewGuid() + ".txt")
    $dest = Join-Path $env:TEMP ("TestArchive_" + [guid]::NewGuid() + ".zip")
    $logFile = Join-Path $env:TEMP ("TestLog_" + [guid]::NewGuid() + ".log")

    Context 'When source does not exist' {
        It 'Should throw if source is missing' {
            { New-Archive -SourcePath $srcFile -DestinationPath $dest -LogFile $logFile } | Should -Throw -ErrorMessage "Source path not found*"
        }
    }

    Context 'When destination exists and no overwrite' {
        BeforeEach {
            Set-Content -Path $srcFile -Value 'dummy' -Force
            Set-Content -Path $dest -Value 'dummy' -Force
        }
        AfterEach {
            if (Test-Path $srcFile) { Remove-Item $srcFile -Force }
            if (Test-Path $dest) { Remove-Item $dest -Force }
        }
        It 'Should throw if destination exists and not overwrite' {
            { New-Archive -SourcePath $srcFile -DestinationPath $dest -LogFile $logFile } | Should -Throw -ErrorMessage "Destination file already exists*"
        }
    }

    Context 'When destination exists and overwrite' {
        BeforeEach {
            Set-Content -Path $srcFile -Value 'dummy' -Force
            Set-Content -Path $dest -Value 'dummy' -Force
        }
        AfterEach {
            if (Test-Path $srcFile) { Remove-Item $srcFile -Force }
            if (Test-Path $dest) { Remove-Item $dest -Force }
        }
        It 'Should remove destination and create archive' {
            New-Archive -SourcePath $srcFile -DestinationPath $dest -Overwrite -LogFile $logFile
            Should -Invoke Remove-Item
        }
    }
}
