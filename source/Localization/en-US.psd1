@{
    "Show-Disclaimer.message"                      = @'
    DISCLAIMER: This data anonymization tool is provided 'as is' without warranty of any kind,
    either express or implied, including but not limited to the implied warranties of merchantability and fitness
    for a particular purpose. It may not detect all data that needs to be anonymized. Therefore, the user must
    review the content of the data before transmitting the data to any internal or external party.
'@
    "Initialize-DsFolder.Start"                    = "Starting initialization of DataSanitizer folder structure at: {0}"
    "Initialize-DsFolder.AddingConfigFolder"       = "Adding _Config folder under root: {0}"
    "Initialize-DsFolder.AddingIntermediateFolder" = "Adding Intermediate {0} folder under root: {1}"
    "Initialize-DsFolder.AddingLogFolder"          = "Adding Log folder under: {0}"
    "Initialize-DsFolder.AddingLogInputFolder"     = "Adding Log Input folder under: {0}"
    "Initialize-DsFolder.CanceledNotEmpty"         = "CANCELED The target folder {0} is not empty. Please provide an empty folder"
    "Initialize-DsFolder.AddingConfigFile"         = "Adding DataSanitizer.cfg.json config file "
    "Initialize-DsFolder.AddingDetectionRulesFile" = "Adding DetectionRules.cfg.json config file in: {0}"
    "New-DSDetectionConfig.Confirmation"           = "New detection rules configuration file created at: {0}"
    "Show-Disclaimer.skipped"                      = "Disclaimer skipped as per configuration"
    "Import-DSConfig.start"                        = "Importing DSConfig settings"
    "Import-DSConfig.defaults"                     = "loading default DSConfig settings"
    "Import-DSConfig.ConfigFilePath"               = "Surcharging default DSConfig settings with: {0}"
    "Import-DSConfig.complete"                     = "DSConfig settingsimport completed"
    "Start-DSFileDetection.StartingFolder"         = "Starting file detection in folder: {0}"
    "Start-DSFileDetection.StartingFile"           = "Starting file detection for file: {0}"
    "Start-DSFileDetection.ProcessingFile"         = "Processing file: {0}"
    "Start-DSFileDetection.UnarchivingZip"         = "Unarchiving ZIP file: {0} to {1}"
    "Start-DSFileDetection.ZipUnarchived"          = "ZIP file extracted to: {0}"
    "Start-DSFileDetection.Start"                  = "Starting DataSanitizer file detection. Input path: {0}"
    "Start-DSFileDetection.InventoryStats"         = "File inventory complete. Hashtable entries: {0}; Indexed array entries: {1}"
    "Start-DSFileDetection.InventorySummary"       = "Inventory summary: {0} files totaling {1}"
    "Start-DSFileDetection.InventoryValidity"      = "Validity: Valid {0} files ({1}); Invalid {2} files ({3})"
    "Start-DSFileDetection.InventoryByExtHeader"   = "Valid files by extension (count / size):"
    "Start-DSFileDetection.InventoryByExtItem"     = "{0}: {1} files ({2})"
}
