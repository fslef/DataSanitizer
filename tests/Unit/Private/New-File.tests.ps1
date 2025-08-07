BeforeAll {
    # Import the function under test
    . "$PSScriptRoot/../../source/Private/New-File.ps1"
    # Mock Write-OutputPadded to avoid actual output/logging
    Mock Write-OutputPadded {}
}

Describe 'New-File' {
    $testFile = Join-Path -Path $env:TEMP -ChildPath ("TestFile_" + [guid]::NewGuid() + ".txt")
    $logFile = Join-Path -Path $env:TEMP -ChildPath ("TestLog_" + [guid]::NewGuid() + ".log")

    Context 'When the file does not exist' {
        BeforeEach {
            if (Test-Path $testFile) { Remove-Item -Path $testFile -Force }
        }
        It 'Should create the file' {
            New-File -FilePath $testFile -LogFile $logFile -IdentLevel 0
            (Test-Path $testFile) | Should -BeTrue
        }
    }

    Context 'When the file already exists' {
        BeforeEach {
            if (-not (Test-Path $testFile)) { New-Item -ItemType File -Path $testFile | Out-Null }
        }
        It 'Should not throw and should keep the file' {
            { New-File -FilePath $testFile -LogFile $logFile -IdentLevel 0 } | Should -Not -Throw
            (Test-Path $testFile) | Should -BeTrue
        }
    }

    Context 'When file creation fails' {
        It 'Should throw an error if New-Item fails' {
            Mock New-Item { throw 'Simulated failure' }
            { New-File -FilePath $testFile -LogFile $logFile -IdentLevel 0 } | Should -Throw -ErrorMessage 'Simulated failure'
        }
    }

    AfterAll {
        if (Test-Path $testFile) { Remove-Item -Path $testFile -Force }
        if (Test-Path $logFile) { Remove-Item -Path $logFile -Force }
    }
}
