@{
    "New-DsFolder.Start"                         = "Starting initialization of DataSanitizer folder structure at: {0}"
    "New-DsFolder.AddingConfigFolder"            = "Adding _Config folder under root: {0}"
    "New-DsFolder.AddingIntermediateFolder"      = "Adding Intermediate {0} folder under root: {1}"
    "New-DsFolder.AddingLogFolder"               = "Adding Log folder under: {0}"
    "New-DsFolder.AddingLogInputFolder"          = "Adding Log Input folder under: {0}"
    "New-DsFolder.AddingLogWorkingFolder"        = "Adding Log Working folder under: {0}"
    "New-DsFolder.CanceledNotEmpty"              = "CANCELED The target folder {0} is not empty. Please provide an empty folder"
    "New-DsFolder.AddingConfigFile"              = "Adding DataSanitizer.cfg.json config file "
    "New-DsFolder.AddingDetectionRulesFile"      = "Adding DetectionRules.cfg.json config file in: {0}"
    "New-DSDetectionConfig.Confirmation"         = "New detection rules configuration file created at: {0}"
    "Import-DSConfig.start"                      = "Importing DSConfig settings"
    "Import-DSConfig.defaults"                   = "loading default DSConfig settings"
    "Import-DSConfig.ConfigFilePath"             = "Surcharging default DSConfig settings with: {0}"
    "Import-DSConfig.complete"                   = "DSConfig settingsimport completed"
    "Start-DSFileDetection.StartingFolder"       = "Starting file detection in folder: {0}"
    "Start-DSFileDetection.StartingFile"         = "Starting file detection for file: {0}"
    "Start-DSFileDetection.ProcessingFile"       = "Processing file: {0}"
    "Start-DSFileDetection.ZipFilesFound"        = "Found {0} ZIP file(s) to extract"
    "Start-DSFileDetection.UnarchivingZip"       = "Unarchiving ZIP file: {0} to {1}"
    "Start-DSFileDetection.ZipUnarchived"        = "ZIP file extracted to: {0}"
    "Start-DSFileDetection.Start"                = "Starting DataSanitizer file detection. Input path: {0}"
    "Start-DSFileDetection.StartInventory"       = "Starting file inventory for path: {0}"
    "Start-DSFileDetection.InventoryStats"       = "File inventory complete. Hashtable entries: {0}; Indexed array entries: {1}"
    "Start-DSFileDetection.InventorySummary"     = "Inventory summary: {0} files totaling {1}"
    "Start-DSFileDetection.InventoryValidity"    = "Validity: Valid {0} files ({1}); Invalid {2} files ({3})"
    "Start-DSFileDetection.InventoryByExtHeader" = "Valid files by extension (count / size):"
    "Start-DSFileDetection.InventoryByExtItem"   = "{0}: {1} files ({2})"
    "Show-Disclaimer.message"                    = @'
DISCLAIMER: DATA SANITIZER TOOL

THIS TOOL IS PROVIDED 'AS IS' WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED.

IMPORTANT LIMITATIONS:
• This tool may not detect all sensitive data that requires anonymization
• Manual review of all processed data is required before sharing
• No guarantee of complete data sanitization

USER RESPONSIBILITY:
You must thoroughly review all output before transmitting data to any internal or external parties.
'@
    "Show-Disclaimer.confirm"                    = "Do you accept the disclaimer and wish to continue with the data sanitization operation?"
    "Show-Disclaimer.skipped"                    = "Disclaimer skipped as per configuration"
    "Show-Disclaimer.accepted"                   = "User accepted the disclaimer. Proceeding with operation."
    "Show-Disclaimer.declined"                   = "User declined the disclaimer. Operation cancelled."
}
