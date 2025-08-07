function New-File {
    <#
    .SYNOPSIS
    Checks if a file exists and creates it if it does not.

    .DESCRIPTION
    Checks if a specified file exists. If not, attempts to create it. Logs status messages using Write-OutputPadded.

    .PARAMETER FilePath
    The path of the file to test and create if it does not exist.

    .PARAMETER IdentLevel
    The level of indentation for the output messages. Default is 0.

    .PARAMETER LogFile
    The path where the log file will be saved.

    .EXAMPLE
    New-File -FilePath "C:\Temp\NewFile.txt"
    Checks if the file "C:\Temp\NewFile.txt" exists and creates it if it does not.

    .EXAMPLE
    New-File -FilePath "C:\Temp\NewFile.txt" -IdentLevel 1
    Checks if the file "C:\Temp\NewFile.txt" exists and creates it if it does not, with an indentation level of 1 for the output messages.

    .NOTES
    Uses Write-OutputPadded for logging.
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [string]$FilePath,

        [Parameter(Mandatory = $false)]
        [int]$IdentLevel = 0,

        [Parameter(Mandatory = $false)]
        [string]$LogFile = $PSLA.Settings.LogFilePath
    )

    if ([string]::IsNullOrWhiteSpace($FilePath)) {
        throw "FilePath cannot be null, empty, or whitespace."
    }

    Write-OutputPadded "Testing file: $FilePath" -IdentLevel $IdentLevel -Type "Debug" -logfile $LogFile

    # Normalize path for cross-platform compatibility
    $resolvedPath = $FilePath
    try {
        $resolvedPath = (Resolve-Path -Path $FilePath -ErrorAction Stop).Path
    } catch {}

    if (-not (Test-Path -Path $resolvedPath -PathType Leaf)) {
        try {
            if ($PSCmdlet.ShouldProcess($resolvedPath, 'Create file')) {
                New-Item -ItemType File -Path $resolvedPath -Force | Out-Null
                Write-OutputPadded "File created: $resolvedPath" -IdentLevel $IdentLevel -Type "Verbose" -logfile $LogFile
            }
        }
        catch {
            Write-OutputPadded "Error creating file: $resolvedPath. Error: $_" -IdentLevel $IdentLevel -Type Error -logfile $LogFile
            throw
        }
    }
    else {
        Write-OutputPadded "File already exists: $resolvedPath" -IdentLevel $IdentLevel -Type "Verbose" -logfile $LogFile
    }
}
