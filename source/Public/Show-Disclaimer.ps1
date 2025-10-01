function Show-Disclaimer {
    [CmdletBinding()]
    param()

    process {
        # Retrieve configured flag; default to $false (do NOT skip) when not defined
        $skip = [bool](Get-PSFConfigValue -FullName 'DataSanitizer.debug.skipDisclaimer' -Fallback $false)
        if (-not $skip) {
            Write-PSFMessage -Module DataSanitizer -Level Warning -String 'Show-Disclaimer.message'
        }
        else {
            Write-PSFMessage -Module DataSanitizer -Level Verbose -String 'Show-Disclaimer.skipped'
        }
    }
}

