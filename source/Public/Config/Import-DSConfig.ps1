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
        # Import both language resource files so that Get-PSFLocalizedString can resolve either language.

        Import-PSFLocalizedString -Module DataSanitizer -Path (Join-Path $PSScriptRoot -ChildPath ./Localization/en-US.psd1) -Language 'en-US'
        Import-PSFLocalizedString -Module DataSanitizer -Path (Join-Path $PSScriptRoot -ChildPath ./Localization/fr-FR.psd1) -Language 'fr-FR'
    }

    process {

        Write-PSFMessage -Level Important -String "Import-DSConfig.start"

        Write-PSFMessage -Level Important -String "Import-DSConfig.defaults"
        Set-PSFConfig -Module DataSanitizer -Name Localization.Language -Value "fr-FR" -Validation string -Initialize -Description "The language the current DataSanitizer session will use for console display" -ModuleExport
        Set-PSFConfig -Module DataSanitizer -Name Localization.LoggingLanguage -Value "fr-FR" -Validation string -Initialize -Description "The language the current DataSanitizer session will use for logging" -ModuleExport
        Set-PSFConfig -Module DataSanitizer -Name Logging.LogFile.CsvDelimiter -Value ';' -Validation string -Initialize -Description "The text delimiter used when exporting to CSV." -ModuleExport
        Set-PSFConfig -Module DataSanitizer -Name Text.Encoding.Default -Value 'utf8' -Validation string -Initialize -Description "The default text encoding to use when reading and writing text files." -ModuleExport
        Set-PSFConfig -Module DataSanitizer -Name path.DSrootFolder -Value '<tbd>' -Validation string -Initialize -Description "The root folder for DataSanitizer." -ModuleExport
        Set-PSFConfig -Module DataSanitizer -Name path.DSConfigFile -Value '<tbd>' -Validation string -Initialize -Description "The full path to the DataSanitizer configuration file." -ModuleExport
        Set-PSFConfig -Module DataSanitizer -Name path.DSIncidentFolder -Value '<tbd>' -Validation string -Initialize -Description "The root incident folder where incident files are stored." -ModuleExport

        # if $ConfigFile, load it
        if ($ConfigFile) {
            Write-PSFMessage -Level Verbose -String "Import-DSConfig.ConfigFilePath" -StringValues $ConfigFile
            try {
                Import-PSFConfig -Path $ConfigFile -Schema MetaJson
                # Update module parameter only if import succeeds
                Set-PSFConfig -Module DataSanitizer -Name path.DSConfigFile -Value $ConfigFile
            } catch {
                # Log error details for troubleshooting
                Write-PSFMessage -Level Error -Message "Failed to import config file: $ConfigFile" -StringValues $_.Exception.Message
            }
        }

        # if debug mode prefernce
        if ($PSBoundParameters.ContainsKey('Debug')) {
            $Config = Get-PSFConfig -Module DataSanitizer | Select-Object FullName,Value
            $Config | ForEach-Object {
                Write-PSFMessage -Level Debug -Message "{0}:{1}" -StringValues $_.FullName, $_.Value
            }
        }



        Write-PSFMessage -Level Significant -String "Import-DSConfig.complete"
    }
}
