function New-Archive {
    <#
        .SYNOPSIS
            Creates a new archive (zip file) from the specified source path.

        .DESCRIPTION
            Creates a zip archive from a source file or directory. Ensures paths are fully qualified and provides an option to overwrite the destination file if it already exists. Logs all actions.

        .PARAMETER SourcePath
            The path to the source file or directory to archive.

        .PARAMETER DestinationPath
            The path to the destination zip file to create.

        .PARAMETER Overwrite
            If specified, allows overwriting of the destination file if it already exists.

        .PARAMETER IdentLevel
            Indentation level for output messages. Default is 0.

        .PARAMETER LogFile
            The path where the log file will be saved.

        .EXAMPLE
            New-Archive -SourcePath "C:\Data\SourceFolder" -DestinationPath "C:\Data\Archive.zip" -Overwrite
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [string]$SourcePath,

        [Parameter(Mandatory = $true)]
        [string]$DestinationPath,

        [Parameter(Mandatory = $false)]
        [switch]$Overwrite,

        [Parameter(Mandatory = $false)]
        [int]$IdentLevel = 0,

        [Parameter(Mandatory = $false)]
        [string]$LogFile = $PSLA.Settings.LogFilePath
    )

    $resolvedSource = $SourcePath
    try {
        $resolvedSource = (Resolve-Path -Path $SourcePath -ErrorAction Stop).Path
    } catch {}

    if (-not (Test-Path -Path $resolvedSource)) {
        throw "Source path not found: $resolvedSource"
    }

    if ((Test-Path -Path $DestinationPath) -and -not $Overwrite) {
        throw "Destination file already exists: $DestinationPath. Use -Overwrite to overwrite."
    }

    if ((Test-Path -Path $DestinationPath) -and $Overwrite) {
        if ($PSCmdlet.ShouldProcess($DestinationPath, 'Remove existing destination archive')) {
            Remove-Item -Path $DestinationPath -Recurse -Force | Out-Null
            Write-OutputPadded "Existing destination archive removed: $DestinationPath" -IdentLevel $IdentLevel -Type Verbose -LogFile $LogFile
        }
    }

    try {
        Write-OutputPadded "Compressing $resolvedSource to $DestinationPath" -IdentLevel $IdentLevel -Type Information -LogFile $LogFile
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        if ($PSCmdlet.ShouldProcess($DestinationPath, "Create archive from $resolvedSource")) {
            if ((Test-Path -Path $resolvedSource -PathType Container)) {
                [System.IO.Compression.ZipFile]::CreateFromDirectory($resolvedSource, $DestinationPath)
            } else {
                $tempFolder = [System.IO.Path]::GetDirectoryName($DestinationPath)
                $tempArchivePath = Join-Path -Path $tempFolder -ChildPath "temp.zip"
                [System.IO.Compression.ZipFile]::CreateFromDirectory((Split-Path -Parent $resolvedSource), $tempArchivePath)
                Move-Item -Path $tempArchivePath -Destination $DestinationPath -Force
            }
            Write-OutputPadded "Archive created successfully at $DestinationPath" -IdentLevel $IdentLevel -Type Success -LogFile $LogFile
        }
    } catch {
        Write-OutputPadded "Failed to create archive: $DestinationPath. Error: $_" -IdentLevel $IdentLevel -Type Error -LogFile $LogFile
        throw
    }
}
