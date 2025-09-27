function Import-DSConfig {
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
    [CmdletBinding(SupportsShouldProcess)]
    param()

    begin {
        # Import both language resource files so that Get-PSFLocalizedString can resolve either language.

        Import-PSFLocalizedString -Module DataSanitizer -Path (Join-Path $PSScriptRoot -ChildPath ./Localization/en-US.psd1) -Language 'en-US'
        Import-PSFLocalizedString -Module DataSanitizer -Path (Join-Path $PSScriptRoot -ChildPath ./Localization/fr-FR.psd1) -Language 'fr-FR'
    }

    process {

        $script:desc_Language = Get-PSFLocalizedString -Module DataSanitizer -Name 'Set-DSConfig.Localization.Language.Description'
        Write-PSFMessage -Level Critical -Message (Get-PSFLocalizedString -Module DataSanitizer -Name 'Set-DSConfig.Localization.Language.Description')
        Set-PSFConfig -Module DataSanitizer -Name Localization.Language -Value "fr-FR" -Validation string -Initialize -Description "En francais" -ModuleExport

        Set-PSFConfig -Module DataSanitizer -Name Localization.LoggingLanguage -Value "fr-FR" -Validation string -Initialize -Description $desc_LoggingLanguage -ModuleExport
        Set-PSFConfig -Module DataSanitizer -Name Logging.LogFile.CsvDelimiter -Value ';' -Validation string -Initialize -Description $desc_CsvDelimiter -ModuleExport
        Set-PSFConfig -Module DataSanitizer -Name Text.Encoding.Default -Value 'utf8' -Validation string -Initialize -Description $desc_TextEncoding -ModuleExport
        Set-PSFConfig -Module DataSanitizer -Name path.DSrootFolder -Value '<tbd>' -Validation string -Initialize -Description $desc_PathRoot -ModuleExport
        Set-PSFConfig -Module DataSanitizer -Name path.DSConfigFile -Value '<tbd>' -Validation string -Initialize -Description $desc_PathConfig -ModuleExport
        Set-PSFConfig -Module DataSanitizer -Name path.DSIncidentFolder -Value '<tbd>' -Validation string -Initialize -Description $desc_PathIncident -ModuleExport
    }
}


