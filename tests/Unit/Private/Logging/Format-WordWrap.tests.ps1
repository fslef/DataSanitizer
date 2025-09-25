BeforeAll {
    # Import the function directly for testing
    . $PSScriptRoot/../../../../source/Private/Logging/Format-WordWrap.ps1
}

Describe Format-WordWrap {
    Context 'When calling the function with basic parameters' {
        It 'Should not throw with minimal parameters' {
            { Format-WordWrap -Message 'Test message' -Width 20 } | Should -Not -Throw
        }

        It 'Should return an array of strings or unwrapped string' {
            $result = Format-WordWrap -Message 'Test message' -Width 20
            # PowerShell may unwrap single-element arrays, so accept both
            ($result -is [System.String[]] -or $result -is [System.String]) | Should -Be $true
        }

        It 'Should return single line for short message' {
            $result = Format-WordWrap -Message 'Short' -Width 20
            $result.Count | Should -Be 1
            $result[0] | Should -Be 'Short'
        }
    }

    Context 'When testing word wrapping functionality' {
        It 'Should wrap long message correctly' {
            $message = 'This is a long message that should be wrapped'
            $result = Format-WordWrap -Message $message -Width 20
            $result.Count | Should -BeGreaterThan 1
            # Each line should not exceed the width
            foreach ($line in $result) {
                $line.Length | Should -BeLessOrEqual 20
            }
        }

        It 'Should handle single word longer than width' {
            $result = Format-WordWrap -Message 'Supercalifragilisticexpialidocious' -Width 10
            $result.Count | Should -Be 1
            $result[0] | Should -Be 'Supercalifragilisticexpialidocious'
        }

        It 'Should preserve word boundaries' {
            $result = Format-WordWrap -Message 'word1 word2 word3' -Width 12
            # Should not break words in the middle - each line should contain complete words
            foreach ($line in $result) {
                # If line contains spaces, it should have complete words on both sides
                if ($line -match '\s') {
                    $line | Should -Match '^\S+(\s+\S+)*$'
                }
            }
        }

        It 'Should handle word exactly at width boundary' {
            $word = 'a' * 10  # 10 character word
            $result = Format-WordWrap -Message $word -Width 10
            $result.Count | Should -Be 1
            $result[0].Length | Should -Be 10
        }
    }

    Context 'When testing edge cases' {
        It 'Should handle empty string' {
            $result = Format-WordWrap -Message '' -Width 20
            # PowerShell may unwrap single empty string, but ensure it behaves correctly
            if ($result -is [array]) {
                $result.Count | Should -Be 1
                $result[0] | Should -Be ''
            } else {
                # If unwrapped, should be empty string
                $result | Should -Be ''
            }
        }

        It 'Should handle whitespace-only string' {
            $result = Format-WordWrap -Message '   ' -Width 20
            # PowerShell may unwrap single empty string, but ensure it behaves correctly
            if ($result -is [array]) {
                $result.Count | Should -Be 1
                $result[0] | Should -Be ''
            } else {
                # If unwrapped, should be empty string
                $result | Should -Be ''
            }
        }

        It 'Should handle single character' {
            $result = Format-WordWrap -Message 'A' -Width 20
            $result.Count | Should -Be 1
            $result[0] | Should -Be 'A'
        }

        It 'Should handle multiple consecutive spaces by normalizing them' {
            $result = Format-WordWrap -Message 'word1     word2' -Width 20
            $result.Count | Should -Be 1
            $result[0] | Should -Be 'word1 word2'
        }

        It 'Should handle width of 1' {
            $result = Format-WordWrap -Message 'AB CD' -Width 1
            # With width 1, each word should be on its own line
            $result.Count | Should -BeGreaterThan 1
        }

        It 'Should handle message with newlines and tabs by normalizing whitespace' {
            $result = Format-WordWrap -Message "Line1`tTabbed`nLine2" -Width 20
            $result.Count | Should -Be 1
            # Newlines and tabs should be treated as word separators, resulting in normal spacing
            $result[0] | Should -Be 'Line1 Tabbed Line2'
        }
    }

    Context 'When testing parameter validation' {
        It 'Should throw for width less than 1' {
            { Format-WordWrap -Message 'Test' -Width 0 } | Should -Throw
        }

        It 'Should throw for negative width' {
            { Format-WordWrap -Message 'Test' -Width -5 } | Should -Throw
        }

        It 'Should accept large width values' {
            { Format-WordWrap -Message 'Test' -Width 1000 } | Should -Not -Throw
        }
    }

    Context 'When testing complex scenarios' {
        It 'Should handle mixed short and long words' {
            $message = 'Short Supercalifragilisticexpialidocious words'
            $result = Format-WordWrap -Message $message -Width 15
            $result.Count | Should -BeGreaterThan 1
            # The long word should be on its own line
            $longWordLine = $result | Where-Object { $_ -match 'Supercalifragilisticexpialidocious' }
            $longWordLine | Should -Not -BeNullOrEmpty
        }

        It 'Should handle message with only spaces' {
            $result = Format-WordWrap -Message '     ' -Width 10
            # PowerShell may unwrap single empty string, but ensure it behaves correctly
            if ($result -is [array]) {
                $result.Count | Should -Be 1
                $result[0] | Should -Be ''
            } else {
                # If unwrapped, should be empty string
                $result | Should -Be ''
            }
        }

        It 'Should handle alternating words and spaces' {
            $message = 'a b c d e'
            $result = Format-WordWrap -Message $message -Width 5
            # Should fit multiple words per line when possible
            $result.Count | Should -BeLessOrEqual 3
        }

        It 'Should not add extra empty lines' {
            $result = Format-WordWrap -Message 'word' -Width 10
            $result.Count | Should -Be 1
            $result[0] | Should -Be 'word'
        }
    }

    Context 'When testing return value consistency' {
        It 'Should always return at least one line' {
            $testCases = @('', '   ', 'word', 'very long message that needs wrapping')
            foreach ($testCase in $testCases) {
                $result = Format-WordWrap -Message $testCase -Width 10
                $result.Count | Should -BeGreaterOrEqual 1
            }
        }

        It 'Should return consistent results for same input' {
            $message = 'Consistent test message'
            $result1 = Format-WordWrap -Message $message -Width 15
            $result2 = Format-WordWrap -Message $message -Width 15
            $result1.Count | Should -Be $result2.Count
            for ($i = 0; $i -lt $result1.Count; $i++) {
                $result1[$i] | Should -Be $result2[$i]
            }
        }
    }
}