BeforeAll {
    # Import the function directly for testing
    . $PSScriptRoot/../../../../source/Private/Logging/Show-LogInfo.ps1
}

Describe Show-LogInfo {
    Context 'When calling the function with basic parameters' {
        It 'Should not throw with minimal parameters' {
            { Show-LogInfo -Message 'Test message' } | Should -Not -Throw
        }

        It 'Should accept message as positional parameter' {
            { Show-LogInfo 'Test message' } | Should -Not -Throw
        }

        It 'Should accept indent as second positional parameter' {
            { Show-LogInfo 'Test message' 2 } | Should -Not -Throw
        }
    }

    Context 'When using MessageType parameter' {
        It 'Should accept valid MessageType <MessageType>' -ForEach @(
            @{ MessageType = 'Information' }
            @{ MessageType = 'Success' }
            @{ MessageType = 'Warning' }
            @{ MessageType = 'Error' }
            @{ MessageType = 'Important' }
            @{ MessageType = 'Verbose' }
            @{ MessageType = 'Debug' }
            @{ MessageType = 'Data' }
        ) {
            { Show-LogInfo -Message 'Test message' -MessageType $MessageType } | Should -Not -Throw
        }
    }

    Context 'When using formatting switches' {
        It 'Should not throw with Title switch' {
            { Show-LogInfo -Message 'Test Title' -Title } | Should -Not -Throw
        }

        It 'Should not throw with Subtitle switch' {
            { Show-LogInfo -Message 'Test Subtitle' -Subtitle } | Should -Not -Throw
        }

        It 'Should not throw with Centered switch' {
            { Show-LogInfo -Message 'Test Centered' -Centered } | Should -Not -Throw
        }

        It 'Should not throw with BlankLine switch' {
            { Show-LogInfo -Message 'Test BlankLine' -BlankLine } | Should -Not -Throw
        }

        It 'Should not throw with valid Bullet and Indent combination' {
            { Show-LogInfo -Message 'Test Bullet' -Bullet -Indent 1 } | Should -Not -Throw
        }
    }

    Context 'When using indentation and width parameters' {
        It 'Should accept valid Indent values' -ForEach @(
            @{ IndentValue = 0 }
            @{ IndentValue = 1 }
            @{ IndentValue = 5 }
        ) {
            { Show-LogInfo -Message 'Test message' -Indent $IndentValue } | Should -Not -Throw
        }

        It 'Should accept custom Width parameter' {
            { Show-LogInfo -Message 'Test message' -Width 80 } | Should -Not -Throw
        }
    }

    Context 'When using log file functionality' {
        BeforeEach {
            $script:tempLogFile = Join-Path $TestDrive 'test.log'
        }

        AfterEach {
            if (Test-Path $script:tempLogFile) {
                Remove-Item $script:tempLogFile -Force
            }
        }

        It 'Should create log file when LogFile parameter is specified' {
            Show-LogInfo -Message 'Test log message' -LogFile $script:tempLogFile
            Test-Path $script:tempLogFile | Should -Be $true
        }

        It 'Should write message to log file' {
            Show-LogInfo -Message 'Test log message' -LogFile $script:tempLogFile
            $logContent = Get-Content $script:tempLogFile -Raw
            $logContent | Should -Match 'Test log message'
        }

        It 'Should include timestamp in log file by default' {
            Show-LogInfo -Message 'Test log message' -LogFile $script:tempLogFile
            $logContent = Get-Content $script:tempLogFile -Raw
            $logContent | Should -Match '\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}'
        }

        It 'Should skip timestamp when SkipTimestamp is specified' {
            Show-LogInfo -Message 'Test log message' -LogFile $script:tempLogFile -SkipTimestamp
            $logContent = Get-Content $script:tempLogFile -Raw
            $logContent | Should -Not -Match '\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}'
        }

        It 'Should include category in log file by default when MessageType is specified' {
            Show-LogInfo -Message 'Test log message' -LogFile $script:tempLogFile -MessageType 'Information'
            $logContent = Get-Content $script:tempLogFile -Raw
            $logContent | Should -Match '\[Information\]'
        }

        It 'Should skip category when SkipCategory is specified' {
            Show-LogInfo -Message 'Test log message' -LogFile $script:tempLogFile -MessageType 'Information' -SkipCategory
            $logContent = Get-Content $script:tempLogFile -Raw
            $logContent | Should -Not -Match '\[Information\]'
        }

        It 'Should work with NoConsole switch when LogFile is specified' {
            { Show-LogInfo -Message 'Test log message' -LogFile $script:tempLogFile -NoConsole } | Should -Not -Throw
            Test-Path $script:tempLogFile | Should -Be $true
        }
    }

    Context 'When testing error conditions' {
        It 'Should throw when NoConsole is used without LogFile' {
            { Show-LogInfo -Message 'Test message' -NoConsole } | Should -Throw "*NoConsole must be used with -LogFile*"
        }

        It 'Should throw when Bullet is used with Indent 0' {
            { Show-LogInfo -Message 'Test message' -Bullet -Indent 0 } | Should -Throw "*Bullet is incompatible with Indent Level 0*"
        }

        It 'Should throw when LogFile is explicitly set to empty string' {
            { Show-LogInfo -Message 'Test message' -LogFile '' } | Should -Throw "*LogFile cannot be null or empty*"
        }

        It 'Should throw when LogFile is explicitly set to null' {
            { Show-LogInfo -Message 'Test message' -LogFile $null } | Should -Throw "*LogFile cannot be null or empty*"
        }
    }

    Context 'When testing preference-based behavior' {
        BeforeEach {
            # Store original preferences
            $script:originalDebugPreference = $DebugPreference
            $script:originalVerbosePreference = $VerbosePreference
        }

        AfterEach {
            # Restore original preferences
            $DebugPreference = $script:originalDebugPreference
            $VerbosePreference = $script:originalVerbosePreference
        }

        It 'Should return early for Debug messages when DebugPreference is not Continue' {
            $DebugPreference = 'SilentlyContinue'
            # This should return early and not throw
            { Show-LogInfo -Message 'Debug message' -MessageType 'Debug' } | Should -Not -Throw
        }

        It 'Should return early for Data messages when DebugPreference is not Continue' {
            $DebugPreference = 'SilentlyContinue'
            # This should return early and not throw
            { Show-LogInfo -Message 'Data message' -MessageType 'Data' } | Should -Not -Throw
        }

        It 'Should return early for Verbose messages when VerbosePreference is not Continue' {
            $VerbosePreference = 'SilentlyContinue'
            # This should return early and not throw
            { Show-LogInfo -Message 'Verbose message' -MessageType 'Verbose' } | Should -Not -Throw
        }
    }

    Context 'When testing word wrapping functionality' {
        It 'Should handle long messages that need wrapping' {
            $longMessage = 'This is a very long message that should be wrapped when the width is exceeded and contains many words that will span multiple lines'
            { Show-LogInfo -Message $longMessage -Width 40 } | Should -Not -Throw
        }

        It 'Should handle messages with effective width calculation for indentation' {
            { Show-LogInfo -Message 'Test message with indentation' -Indent 3 -Width 50 } | Should -Not -Throw
        }

        It 'Should handle messages with bullet point width calculation' {
            { Show-LogInfo -Message 'Test bullet message' -Bullet -Indent 2 -Width 50 } | Should -Not -Throw
        }
    }

    Context 'When testing combined formatting options' {
        It 'Should work with Title and Centered together' {
            { Show-LogInfo -Message 'Centered Title' -Title -Centered } | Should -Not -Throw
        }

        It 'Should work with MessageType and formatting switches together' {
            { Show-LogInfo -Message 'Important Title' -Title -MessageType 'Important' } | Should -Not -Throw
        }

        It 'Should work with all compatible options together' {
            { Show-LogInfo -Message 'Complex message' -MessageType 'Information' -Indent 1 -Width 100 -BlankLine } | Should -Not -Throw
        }
    }
}