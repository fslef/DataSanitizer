function Import-DsConfig {
    <#
        .SYNOPSIS
            Initialize or update DataSanitizer configuration values.
        .DESCRIPTION
            Imports localized resources (en-US, fr-FR) and creates configuration keys if they do not yet exist.
            Honors an already defined DataSanitizer.Localization.Language or PSFramework.Localization.Language value
            instead of hard-forcing en-US. All description strings are localized.
        .NOTES
            Re-running this function is idempotent; existing values are preserved unless they were never initialized.
        .EXAMPLE
            Set-DSConfig
            Initializes all baseline configuration keys (if missing) using the preferred language resolved from existing settings or the PSFramework default.
        .EXAMPLE
            Set-DSConfig -Verbose
            Runs initialization showing verbose output, including a localized completion message.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [PsfFileSingle]$ConfigFile
    )

    begin {
        Initialize-DSModuleSession
    }

    process {

        Write-PSFMessage -Module DataSanitizer -Level Important -String 'Import-DSConfig.Start'

        # if $ConfigFile, load it
        if ($ConfigFile) {
            Write-PSFMessage -Module DataSanitizer -Level Verbose -String 'Import-DSConfig.ConfigFilePath' -StringValues $ConfigFile
            try {
                Import-PSFConfig -Path $ConfigFile -Schema MetaJson
                # Update module parameter only if import succeeds
                Set-PSFConfig -Module DataSanitizer -Name Path.DSConfigFile -Value $ConfigFile
            }
            catch {
                # Log error details for troubleshooting
                Write-PSFMessage -Module DataSanitizer -Level Error -Message "Failed to import config file: $ConfigFile" -StringValues $_.Exception.Message
            }
        }

        # if debug mode prefernce
        if ($PSBoundParameters.ContainsKey('Debug')) {
            $Config = Get-PSFConfig -Module DataSanitizer | Select-Object FullName, Value
            $Config | ForEach-Object {
                Write-PSFMessage -Module DataSanitizer -Level Debug -Message "{0}:{1}" -StringValues $_.FullName, $_.Value
            }
        }


        Write-PSFMessage -Module DataSanitizer -Level Significant -String 'Import-DSConfig.complete'
    }
}

