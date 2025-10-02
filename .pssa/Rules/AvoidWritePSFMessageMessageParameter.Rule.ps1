function AvoidWritePSFMessageMessageParameter {
    <#
        .SYNOPSIS
            PSScriptAnalyzer custom rule to discourage using Write-PSFMessage with -Message.
        .DESCRIPTION
            Flags any usage of Write-PSFMessage that supplies the -Message parameter. Team standard
            mandates using -String (with localized string keys) and optionally -StringValues instead,
            to enforce consistent localization and formatting.

            Rule Name: AvoidWritePSFMessageMessageParameter
            Severity:  Warning (can be escalated to Error in settings if desired)
            Non-shipping: Located under .pssa/Rules to keep dev-only tooling separate from module payload.

        .LINK
            https://github.com/PowerShell/PSScriptAnalyzer/blob/master/README.md#custom-rules
    #>
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord])]
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.Language.ScriptBlockAst] $Ast,
        [string] $FileName
    )

    $commands = $Ast.FindAll({ param($n) $n -is [System.Management.Automation.Language.CommandAst] }, $true)
    foreach ($command in $commands) {
        $name = $command.GetCommandName()
        if (-not $name) { continue }
        if ($name -ine 'Write-PSFMessage') { continue }

        foreach ($element in $command.CommandElements) {
            if ($element -is [System.Management.Automation.Language.CommandParameterAst] -and $element.ParameterName -ieq 'Message') {
                [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                    Message              = "Avoid using -Message with Write-PSFMessage. Use -String (and -StringValues if needed) for localization consistency."
                    Extent               = $element.Extent
                    RuleName             = 'AvoidWritePSFMessageMessageParameter'
                    Severity             = 'Warning'
                    ScriptName           = $FileName
                    Line                 = $element.Extent.StartLineNumber
                    Column               = $element.Extent.StartColumnNumber
                    SuggestedCorrections = @()
                }
            }
        }
    }
}