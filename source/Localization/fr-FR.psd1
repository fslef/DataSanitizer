@{
    "Initialize-DsFolder.Start"                    = "Démarrage de l'initialisation de la structure de dossiers de DataSanitizer à : {0}"
    "Initialize-DsFolder.AddingConfigFolder"       = "Ajout du dossier _Config sous la racine : {0}"
    "Initialize-DsFolder.AddingIntermediateFolder" = "Ajout du dossier Intermediate {0} sous la racine {0}"
    "Initialize-DsFolder.AddingLogFolder"          = "Ajout du dossier de Log sous: {0}"
    "Initialize-DsFolder.AddingLogInputFolder"     = "Ajout du dossier de Log Input sous: {0}"
    "Initialize-DsFolder.AddingConfigFile"         = "Ajout du fichier de configuration DataSanitizer.cfg.json"
    "Initialize-DsFolder.AddingDetectionRulesFile" = "Ajout du fichier de configuration DetectionRules.cfg.json dans : {0}"
    "New-DSDetectionConfig.Confirmation"           = "Nouveau fichier de configuration de règle de détection créé: {0}"
    "Import-DSConfig.start"                        = "Import des paramètres de DSConfig"
    "Import-DSConfig.defaults"                     = "Chargement des paramètres par défaut de DSConfig"
    "Import-DSConfig.ConfigFilePath"               = "Surcharge des paramètres par défaut de DSConfig avec : {0}"
    "Import-DSConfig.complete"                     = "Import des paramètres de DSConfig terminée"
    "Start-DSFileDetection.StartingFolder"         = "Démarrage de la détection de fichiers dans le dossier : {0}"
    "Start-DSFileDetection.StartingFile"           = "Démarrage de la détection de fichiers pour le fichier : {0}"
    "Start-DSFileDetection.ProcessingFile"         = "Traitement du fichier : {0}"
    "Start-DSFileDetection.ZipFilesFound"          = "Trouvé {0} fichier(s) ZIP à extraire"
    "Start-DSFileDetection.UnarchivingZip"         = "Décompression du fichier ZIP : {0} vers {1}"
    "Start-DSFileDetection.ZipUnarchived"          = "Fichier ZIP extrait vers : {0}"
    "Start-DSFileDetection.InventorySummary"       = "Résumé inventaire : {0} fichiers pour un total de {1}"
    "Start-DSFileDetection.InventoryValidity"      = "Validité : Valides {0} fichiers ({1}); Invalides {2} fichiers ({3})"
    "Start-DSFileDetection.InventoryByExtHeader"   = "Fichiers valides par extension (compte / taille) :"
    "Start-DSFileDetection.InventoryByExtItem"     = "{0} : {1} fichiers ({2})"
    "Start-DSFileDetection.Start"                  = "Démarrage de la détection de fichiers DataSanitizer. Chemin d'entrée : {0}"
    "Start-DSFileDetection.StartInventory"         = "Démarrage de l'inventaire des fichiers pour le chemin : {0}"
    "Start-DSFileDetection.InventoryStats"         = "Inventaire des fichiers terminé. Entrées Hashtable : {0}; Entrées du tableau indexé : {1}"
    "Show-Disclaimer.message"                      = @'
AVERTISSEMENT : OUTIL DE NETTOYAGE DES DONNÉES

Cet outil est fourni « en l'état » sans garantie d'aucune sorte, expresse ou implicite.

LIMITATIONS IMPORTANTES :
• Cet outil peut ne pas détecter toutes les données sensibles nécessitant une anonymisation
• Une révision manuelle de toutes les données traitées est requise avant le partage
• Aucune garantie d'anonymisation complète des données

RESPONSABILITÉ DE L'UTILISATEUR :
Vous devez examiner minutieusement tous les résultats avant de transmettre des données à un tiers interne ou externe.
'@
    "Show-Disclaimer.confirm"                      = "Acceptez-vous l'avertissement et souhaitez-vous continuer avec l'opération de nettoyage des données ?"
    "Show-Disclaimer.skipped"                      = "Avertissement ignoré conformément à la configuration"
    "Show-Disclaimer.accepted"                     = "L'utilisateur a accepté l'avertissement. Poursuite de l'opération."
    "Show-Disclaimer.declined"                     = "L'utilisateur a refusé l'avertissement. Opération annulée."
}
