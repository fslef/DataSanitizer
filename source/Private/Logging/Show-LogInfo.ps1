function Show-LogInfo {
    <#
    .SYNOPSIS
        Writes formatted and colorized output to the console or log file.
    .DESCRIPTION
        Supports indentation, centering, bullet points, titles, subtitles, and logging to a file with optional timestamps and categories.
    .PARAMETER Message
        The message to be written to the console or log file.
    .PARAMETER Indent
        Indentation level for the output message. Default is 0.
    .PARAMETER Width
        Width of the output message. Default is 120.
    .PARAMETER Centered
        If set, output message will be centered.
    .PARAMETER Title
        If set, output message will be formatted as a title.
    .PARAMETER Subtitle
        If set, output message will be formatted as a subtitle with '-> ' prefix and dashed separator line.
    .PARAMETER MessageType
        Type of the message. Determines color. One of: Information, Success, Warning, Error, Important, Verbose, Debug, Data.
    .PARAMETER BlankLine
        If set, a blank line will be written before the output message.
    .PARAMETER LogFile
        Path to the log file where the output message will be logged. Defaults to $psla.settings.LogFilePath if not provided.
    .PARAMETER SkipTimestamp
        If set, do not prepend a timestamp to the log line. By default, a timestamp is included.
    .PARAMETER SkipCategory
        If set, do not prepend the message category to the log line. By default, the category is included when available.
    .PARAMETER Pause
        If set, prompts the user to press Enter to continue after displaying the output.
    .PARAMETER NoConsole
        If set, output will be logged to the log file but not displayed on the console.
    .PARAMETER Bullet
        If set, adds "- " as a text prefix for bullet points, adjusting indentation. Not compatible with Indent = 0.
    .EXAMPLE
        Write-LogInfo -Message "Hello, World!" -MessageType "Information"
    .EXAMPLE
        Write-LogInfo -Message "This is a warning" -MessageType "Warning" -Indent 2
    .EXAMPLE
        Write-LogInfo -Message "Centered Title" -Title -Centered
    .EXAMPLE
        Write-LogInfo -Message "Bullet Point" -Bullet -Indent 1
    .EXAMPLE
    Write-LogInfo -Message "Log this message" -LogFile "log.txt"   # includes timestamp and category by default
    .EXAMPLE
        Write-LogInfo -Message "Press Enter to continue" -Pause
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$Message,
        [Parameter(Position = 1, Mandatory = $false)]
        [int]$Indent = 0,
        [Parameter(Mandatory = $false)]
        [int]$Width = 120,
        [Parameter(Mandatory = $false)]
        [switch]$Centered = $false,
        [Parameter(Mandatory = $false)]
        [switch]$Title = $false,
        [Parameter(Mandatory = $false)]
        [switch]$Subtitle = $false,
        [Parameter(Mandatory = $false)]
        [ValidateSet("Information", "Success", "Warning", "Error", "Important", "Verbose", "Debug", "Data")]
        [string]$MessageType,
        [Parameter(Mandatory = $false)]
        [switch]$BlankLine = $false,
        [Parameter(Mandatory = $false)]
        [String]$LogFile,
        [Parameter(Mandatory = $false)]
        [switch]$SkipTimestamp = $false,
        [Parameter(Mandatory = $false)]
        [switch]$SkipCategory = $false,
        [Parameter(Mandatory = $false)]
        [switch]$Pause = $false,
        [Parameter(Mandatory = $false)]
        [switch]$NoConsole = $false,
        [Parameter(Mandatory = $false)]
        [switch]$Bullet = $false
    )
    # Use module-level default log file path if not provided by caller
    if (-not $PSBoundParameters.ContainsKey('LogFile') -or [string]::IsNullOrWhiteSpace($LogFile)) {
        $defaultLogFile = $null
        # Prefer module script scope if available
        if ($PSBoundParameters.ContainsKey('psla')) { }
        if ($null -ne $script:psla -and $null -ne $script:psla.settings -and $null -ne $script:psla.settings.LogFilePath) {
            $defaultLogFile = $script:psla.settings.LogFilePath
        }
        elseif ($null -ne $psla -and $null -ne $psla.settings -and $null -ne $psla.settings.LogFilePath) {
            # Fallback to unscoped variable if present
            $defaultLogFile = $psla.settings.LogFilePath
        }
        if (-not [string]::IsNullOrWhiteSpace($defaultLogFile)) {
            $LogFile = $defaultLogFile
        }
    }
    # Skip output for Debug/Data/Verbose if not enabled in script preferences
    if ((($MessageType -eq "Debug" -or $MessageType -eq "Data") -and $DebugPreference -ne "Continue") -or
        ($MessageType -eq "Verbose" -and $VerbosePreference -ne "Continue")) {
        return
    }
    # Enforce that -NoConsole is only valid with -LogFile (otherwise output is lost)
    if ($NoConsole -and -not $LogFile) {
        throw "-NoConsole must be used with -LogFile"
    }
    # Prevent bullet formatting with no indentation (would break alignment)
    if ($Bullet -and $Indent -eq 0) {
        throw "-Bullet is incompatible with Indent Level 0"
    }
    # Defensive: Don't allow empty log file path if explicitly set
    if ($PSBoundParameters.ContainsKey('LogFile') -and [string]::IsNullOrWhiteSpace($LogFile)) {
        throw "-LogFile cannot be null or empty."
    }
    $indentSpaces = ' ' * ($Indent * 4)
    $bulletPrefix = $Bullet ? ('- ') : ''
    $linePrefix = $Bullet ? ($indentSpaces.Substring(0, $indentSpaces.Length - 2) + $bulletPrefix) : $indentSpaces
    $effectiveWidth = $Width - $linePrefix.Length
    # Custom word wrap to fit message to effective width (avoids external dependencies)
    $wrappedLines = @()
    $words = $Message -split '\s+'
    $currentLine = ''
    foreach ($word in $words) {
        if (($currentLine.Length + $word.Length + 1) -le $effectiveWidth) {
            $currentLine += ($currentLine.Length -gt 0 ? ' ' : '') + $word
        }
        else {
            $wrappedLines += $currentLine
            $currentLine = $word
        }
    }
    if ($currentLine) { $wrappedLines += $currentLine }
    if ($BlankLine) {
        # PSScriptAnalyzer: disable=PSAvoidUsingWriteHost
        Write-Host ""
    }
    if ($Title -and !$NoConsole) {
        # PSScriptAnalyzer: disable=PSAvoidUsingWriteHost
        Write-Host ('=' * $Width)
    }
    foreach ($line in $wrappedLines) {
        $outputLine = $line
        $padding = $linePrefix
        if ($Centered -or $Title) {
            $totalPadding = $Width - $line.Length
            $leftPadding = [math]::Floor($totalPadding / 2)
            $padding = ' ' * ($leftPadding + ($Indent * 4))
        }
        if (!$NoConsole) {
            if ($Subtitle) {
                # Subtitle formatting: yellow with arrow and separator
                # PSScriptAnalyzer: disable=PSAvoidUsingWriteHost
                Write-Host ($padding + '-> ' + $outputLine) -ForegroundColor Yellow
                # PSScriptAnalyzer: disable=PSAvoidUsingWriteHost
                Write-Host ($padding + ('-' * ($Width - ($Indent * 4))))
                continue
            }
            switch ($MessageType) {
                "Information" {
                    # PSScriptAnalyzer: disable=PSAvoidUsingWriteHost
                    Write-Host ($padding + $outputLine) -ForegroundColor Cyan
                }
                "Success" {
                    # PSScriptAnalyzer: disable=PSAvoidUsingWriteHost
                    Write-Host ($padding + $outputLine) -ForegroundColor Green
                }
                "Warning" {
                    # PSScriptAnalyzer: disable=PSAvoidUsingWriteHost
                    Write-Host ($padding + $outputLine) -ForegroundColor Black -BackgroundColor DarkYellow
                }
                "Error" {
                    # PSScriptAnalyzer: disable=PSAvoidUsingWriteHost
                    Write-Host ($padding + $outputLine) -ForegroundColor Red
                }
                "Important" {
                    # PSScriptAnalyzer: disable=PSAvoidUsingWriteHost
                    Write-Host ($padding + $outputLine) -ForegroundColor White -BackgroundColor DarkRed
                }
                "Verbose" {
                    if ($VerbosePreference -eq "Continue") {
                        # PSScriptAnalyzer: disable=PSAvoidUsingWriteHost
                        Write-Host ($padding + $outputLine) -ForegroundColor DarkGray
                    }
                }
                "Debug" {
                    if ($DebugPreference -eq "Continue") {
                        # PSScriptAnalyzer: disable=PSAvoidUsingWriteHost
                        Write-Host ($padding + $outputLine) -ForegroundColor DarkGray
                    }
                }
                "Data" {
                    if ($DebugPreference -eq "Continue") {
                        # PSScriptAnalyzer: disable=PSAvoidUsingWriteHost
                        Write-Host ($padding + $outputLine) -ForegroundColor Magenta
                    }
                }
                default {
                    # PSScriptAnalyzer: disable=PSAvoidUsingWriteHost
                    Write-Host ($padding + $outputLine)
                }
            }
        }
        if ($Title -and !$NoConsole) {
            # PSScriptAnalyzer: disable=PSAvoidUsingWriteHost
            Write-Host ('-' * $Width)
        }
    }
    # Log to file if LogFile is set and not empty
    if ($LogFile -and -not [string]::IsNullOrWhiteSpace($LogFile)) {
        foreach ($line in $wrappedLines) {
            $logLine = $line
            if (-not $SkipCategory) {
                $paddedType = $Title ? ''.PadRight(13) : ($MessageType ? ("[$MessageType]".PadRight(13)) : ' '.PadRight(13))
                $logLine = "$paddedType $logLine"
            }
            if (-not $SkipTimestamp) {
                $logLine = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss ')$logLine"
            }
            if ($Title -or $Subtitle) {
                # Title/subtitle formatting in log file
                if ($Title -and $LogFile -and -not [string]::IsNullOrWhiteSpace($LogFile)) { Out-File -FilePath $LogFile -Append -InputObject ('=' * $line.Length) }
                if ($LogFile -and -not [string]::IsNullOrWhiteSpace($LogFile)) { Out-File -FilePath $LogFile -Append -InputObject $logLine }
                if ($Title -and $LogFile -and -not [string]::IsNullOrWhiteSpace($LogFile)) { Out-File -FilePath $LogFile -Append -InputObject ('-' * $line.Length) }
            }
            else {
                if ($LogFile -and -not [string]::IsNullOrWhiteSpace($LogFile)) { Out-File -FilePath $LogFile -Append -InputObject $logLine }
            }
        }
    }
    if ($Pause) {
        # Pause for user input; abort if not Enter (safety: avoid accidental continuation)
        $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        if ($key.Character -ne "`r") {
            throw "Script execution aborted by user."
        }
    }
}