function Initialize-DSConfigDefault {
    [CmdletBinding()]
    param()

    process {

        Clear-PSFMessage -Module DataSanitizer

        Import-PSFLocalizedString -Module DataSanitizer -Path (Join-Path $PSScriptRoot -ChildPath './Localization/en-US.psd1') -Language 'en-US'
        Import-PSFLocalizedString -Module DataSanitizer -Path (Join-Path $PSScriptRoot -ChildPath './Localization/fr-FR.psd1') -Language 'fr-FR'

        Set-DSDefaultConfig

    }
}
