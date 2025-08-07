BeforeAll {
    # Import the function under test
    . "$PSScriptRoot/../../source/Private/New-Folder.ps1"
    # Mock Write-OutputPadded to avoid actual output/logging
    Mock Write-OutputPadded {}
}

Describe 'New-Folder' {
    $testFolder = Join-Path -Path $env:TEMP -ChildPath ("TestFolder_" + [guid]::NewGuid())
    $logFile = Join-Path -Path $env:TEMP -ChildPath ("TestLog_" + [guid]::NewGuid() + ".log")

    Context 'When the folder does not exist' {
        BeforeEach {
            if (Test-Path $testFolder) { Remove-Item -Path $testFolder -Recurse -Force }
        }
        It 'Should create the folder' {
            New-Folder -FolderPath $testFolder -LogFile $logFile -IdentLevel 0
            (Test-Path $testFolder) | Should -BeTrue
        }
    }

    Context 'When the folder already exists' {
        BeforeEach {
            if (-not (Test-Path $testFolder)) { New-Item -ItemType Directory -Path $testFolder | Out-Null }
        }
        It 'Should not throw and should keep the folder' {
            { New-Folder -FolderPath $testFolder -LogFile $logFile -IdentLevel 0 } | Should -Not -Throw
            (Test-Path $testFolder) | Should -BeTrue
        }
    }

    Context 'When folder creation fails' {
        It 'Should throw an error if New-Item fails' {
            Mock New-Item { throw 'Simulated failure' }
            { New-Folder -FolderPath $testFolder -LogFile $logFile -IdentLevel 0 } | Should -Throw -ErrorMessage 'Simulated failure'
        }
    }

    AfterAll {
        if (Test-Path $testFolder) { Remove-Item -Path $testFolder -Recurse -Force }
        if (Test-Path $logFile) { Remove-Item -Path $logFile -Force }
    }
}
