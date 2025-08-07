function Expand-MyArchive {
    <#
    .SYNOPSIS
        Expands the specified archive file to the given destination path.

    .DESCRIPTION
        Extracts an archive file (e.g., zip) to the specified destination. Ensures paths are fully qualified and creates the destination directory if it does not exist. Logs all actions.

    .PARAMETER ArchivePath
        The path to the archive file to expand.

    .PARAMETER DestinationPath
        The path to the directory where the contents will be extracted.

    .PARAMETER IdentLevel
        Indentation level for output messages. Default is 0.

    .PARAMETER Overwrite
        If specified, overwrites existing files in the destination directory.

    .PARAMETER LogFile
        The path where the log file will be saved.

    .EXAMPLE
        Expand-MyArchive -ArchivePath "C:\Data\Archive.zip" -DestinationPath "C:\Data\ExtractedFiles" -Overwrite
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ArchivePath,

        [Parameter(Mandatory = $true)]
        [string]$DestinationPath,

        [Parameter(Mandatory = $false)]
        [int]$IdentLevel = 0,

        [Parameter(Mandatory = $false)]
        [switch]$Overwrite,

        [Parameter(Mandatory = $false)]
        [string]$LogFile = $PSLA.Settings.LogFilePath
    )

    $ArchivePathFull = $ArchivePath
    $DestinationPathFull = $DestinationPath

    if (-not (Test-Path -Path $ArchivePathFull -PathType Leaf)) {
        Write-OutputPadded "Archive file not found: $ArchivePath" -IdentLevel $IdentLevel -Type Error -LogFile $LogFile
        throw "Archive file not found: $ArchivePath"
    }

    if ($Overwrite -and (Test-Path -Path $DestinationPathFull -PathType Container) -and ($PSLA.Debug.SkipArchiveExtraction -ne $true)) {
        if ($PSCmdlet.ShouldProcess($DestinationPathFull, 'Remove destination directory for overwrite')) {
            Remove-Item -Path $DestinationPathFull -Recurse -Force | Out-Null
            Write-OutputPadded "Destination directory removed: $DestinationPath" -IdentLevel $IdentLevel -Type Verbose -LogFile $LogFile
        }
    }

    if ($PSCmdlet.ShouldProcess($DestinationPathFull, 'Create destination directory')) {
        New-Folder $DestinationPathFull -IdentLevel $IdentLevel -LogFile $LogFile
    }

    Write-OutputPadded "Destination directory: $DestinationPath" -IdentLevel $IdentLevel -Type Verbose -LogFile $LogFile

    if (!$PSLA.Debug.SkipArchiveExtraction) {
        try {
            Add-Type -AssemblyName System.IO.Compression.FileSystem
            if ($PSCmdlet.ShouldProcess($ArchivePathFull, "Extract archive to $DestinationPathFull")) {
                Expand-Archive -Path $ArchivePathFull -DestinationPath $DestinationPathFull
                Write-OutputPadded "Archive extracted successfully to: $DestinationPath" -IdentLevel $IdentLevel -Type Success -LogFile $LogFile
            }
        } catch {
            Write-OutputPadded "Error extracting archive: $ArchivePath to $DestinationPath. Error: $_" -IdentLevel $IdentLevel -Type Error -LogFile $LogFile
            throw
        }
    } else {
        Write-OutputPadded "[Simulated] Archive extracted successfully to: $DestinationPath" -IdentLevel $IdentLevel -Type Success -LogFile $LogFile
    }
}
