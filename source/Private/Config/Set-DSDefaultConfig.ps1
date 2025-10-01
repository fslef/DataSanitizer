function Set-DSDefaultConfig {
    [CmdletBinding()]
    param()

    process {

        Write-PSFMessage -Module DataSanitizer -Level Important -String 'Import-DSConfig.defaults'

        Set-PSFConfig -Module DataSanitizer -Name Localization.Language -Value "fr-FR" -Validation string -Initialize -Description "The language the current DataSanitizer session will use for console display" -ModuleExport
        Set-PSFConfig -Module DataSanitizer -Name Localization.LoggingLanguage -Value "fr-FR" -Validation string -Initialize -Description "The language the current DataSanitizer session will use for logging" -ModuleExport
        Set-PSFConfig -Module DataSanitizer -Name Logging.LogFile.CsvDelimiter -Value ';' -Validation string -Initialize -Description "The text delimiter used when exporting to CSV." -ModuleExport
        Set-PSFConfig -Module DataSanitizer -Name Text.Encoding.Default -Value 'utf8' -Validation string -Initialize -Description "The default text encoding to use when reading and writing text files." -ModuleExport
        Set-PSFConfig -Module DataSanitizer -Name Path.DSrootFolder -Value '<tbd>' -Validation string -Initialize -Description "The root folder for DataSanitizer." -ModuleExport
        Set-PSFConfig -Module DataSanitizer -Name Path.DSConfigFile -Value '<tbd>' -Validation string -Initialize -Description "The full path to the DataSanitizer configuration file." -ModuleExport
        Set-PSFConfig -Module DataSanitizer -Name Path.DSIncidentFolder -Value '<tbd>' -Validation string -Initialize -Description "The root incident folder where incident files are stored." -ModuleExport

    }
}
