function Initialize-DSModuleSession {
    [CmdletBinding()]
    param()

    process {


        Import-PSFLocalizedString -Module DataSanitizer -Path (Join-Path $PSScriptRoot -ChildPath './Localization/en-US.psd1') -Language 'en-US'
        Import-PSFLocalizedString -Module DataSanitizer -Path (Join-Path $PSScriptRoot -ChildPath './Localization/fr-FR.psd1') -Language 'fr-FR'

        Write-PSFMessage -Module DataSanitizer -Level Important -String 'Import-DSConfig.defaults'

        Set-PSFConfig -Module DataSanitizer -Name Logging.LogFile.CsvDelimiter -Value ';' -Validation string -Initialize -Description "The text delimiter used when exporting to CSV." -ModuleExport
        Set-PSFConfig -Module DataSanitizer -Name Text.Encoding.Default -Value 'utf8' -Validation string -Initialize -Description "The default text encoding to use when reading and writing text files." -ModuleExport
        Set-PSFConfig -Module DataSanitizer -Name Path.DSrootFolder -Value '<tbd>' -Validation string -Initialize -Description "The root folder for DataSanitizer." -ModuleExport
        Set-PSFConfig -Module DataSanitizer -Name Path.DSConfigFile -Value '<tbd>' -Validation string -Initialize -Description "The config file for DataSanitizer." -ModuleExport
        Set-PSFConfig -Module DataSanitizer -Name Path.DSLogInputFolder -Value '<tbd>' -Validation string -Initialize -Description "The Log Input folder where log files are stored." -ModuleExport
        Set-PSFConfig -Module DataSanitizer -Name Path.DSLogWorkingFolder -Value '<tbd>' -Validation string -Initialize -Description "The Log Working folder from where files are processed." -ModuleExport

        Set-DSDefaultConfig

    }
}
