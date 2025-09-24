BeforeAll {
    # Import the function directly for testing
    . $PSScriptRoot/../../../source/Private/Get-PrivateFunction.ps1
}

AfterAll {
    # No module cleanup needed since we're not loading a module
}

Describe Get-PrivateFunction {
    Context 'When calling the function with string value' {
        It 'Should return a single object' {
            $return = Get-PrivateFunction -PrivateData 'string'

            ($return | Measure-Object).Count | Should -Be 1
        }

        It 'Should return a string based on the parameter PrivateData' {
            $return = Get-PrivateFunction -PrivateData 'string'

            $return | Should -Be 'string'
        }
    }
}

