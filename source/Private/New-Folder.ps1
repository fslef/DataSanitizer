function New-Folder {
    <#
    .SYNOPSIS
    Tests if a folder exists and creates it if it does not.

    .DESCRIPTION
    Checks if a specified folder exists. If not, attempts to create it. Logs status messages using Write-OutputPadded.

    .PARAMETER FolderPath
    The path of the folder to test and create if it does not exist.

    .PARAMETER IdentLevel
    The level of indentation for the output messages. Default is 0.

    .PARAMETER LogFile
    The path where the log file will be saved.

    .EXAMPLE
    New-Folder -FolderPath "C:\Temp\NewFolder"
    Tests if the folder "C:\Temp\NewFolder" exists and creates it if it does not.

    .EXAMPLE
    New-Folder -FolderPath "C:\Temp\NewFolder" -IdentLevel 1
    Tests if the folder "C:\Temp\NewFolder" exists and creates it if it does not, with an indentation level of 1 for the output messages.

    .NOTES
    Uses Write-OutputPadded for logging.
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [string]$FolderPath,

        [Parameter(Mandatory = $false)]
        [int]$IdentLevel = 0,

        [Parameter(Mandatory = $false)]
        [string]$LogFile = $PSLA.Settings.LogFilePath
    )

    if ([string]::IsNullOrWhiteSpace($FolderPath)) {
        throw "FolderPath cannot be null, empty, or whitespace."
    }

    Write-OutputPadded "Testing folder: $FolderPath" -IdentLevel $IdentLevel -Type "Debug" -logfile $LogFile

    if (-not (Test-Path -Path $FolderPath -PathType Container)) {
        try {
            if ($PSCmdlet.ShouldProcess($FolderPath, 'Create directory')) {
                New-Item -ItemType Directory -Path $FolderPath -Force | Out-Null
                Write-OutputPadded "Folder created: $FolderPath" -IdentLevel $IdentLevel -Type "Verbose" -logfile $LogFile
            }
        }
        catch {
            # Log and rethrow with context
            Write-OutputPadded "Error creating folder: $FolderPath. Error: $_" -IdentLevel $IdentLevel -Type Error -logfile $LogFile
            throw
        }
    }
    else {
        Write-OutputPadded "Folder already exists: $FolderPath" -IdentLevel $IdentLevel -Type "Verbose" -logfile $LogFile
    }
}
