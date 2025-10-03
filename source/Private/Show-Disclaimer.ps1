function Show-Disclaimer {
    [CmdletBinding()]
    param()

    process {
        # Retrieve configured flag; default to $false (do NOT skip) when not defined
        $skipDisclaimer = [bool](Get-PSFConfigValue -FullName 'DataSanitizer.Debug.SkipDisclaimer' -Fallback $false)
        if (-not $skipDisclaimer) {
            Write-PSFMessage -Module DataSanitizer -Level Warning -String 'Show-Disclaimer.message'

            # Get user confirmation before proceeding using PSFramework's user choice
            $choice = Get-PSFUserChoice -Caption 'DataSanitizer Disclaimer' -Message 'Show-Disclaimer.confirm' -Options 'Accept', 'Decline' -DefaultChoice 1
            if ($choice -eq 'Decline') {
                Write-PSFMessage -Module DataSanitizer -Level Warning -String 'Show-Disclaimer.declined'
                Break
            }
            Write-PSFMessage -Module DataSanitizer -Level Verbose -String 'Show-Disclaimer.accepted'
        }
        else {
            Write-PSFMessage -Module DataSanitizer -Level Verbose -String 'Show-Disclaimer.skipped'
        }
    }
}

