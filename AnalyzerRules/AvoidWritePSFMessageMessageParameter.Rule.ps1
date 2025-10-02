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

        .NOTES
            This is a script-based custom rule. It is discovered when its containing folder is added
            to CustomRulePath in PSScriptAnalyzer settings.

        .LINK
            https://github.com/PowerShell/PSScriptAnalyzer/blob/master/README.md#custom-rules
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.Language.ScriptBlockAst] $Ast,
        [string] $FileName
    )

    # Find all command ASTs; filter to Write-PSFMessage (case-insensitive)
    $commands = $Ast.FindAll({ param($n) $n -is [System.Management.Automation.Language.CommandAst] }, $true)
    foreach ($command in $commands) {
        $name = $command.GetCommandName()
        if (-not $name) { continue }
        if ($name -ine 'Write-PSFMessage') { continue }

        foreach ($element in $command.CommandElements) {
            if ($element -is [System.Management.Automation.Language.CommandParameterAst]) {
                if ($element.ParameterName -ieq 'Message') {
                    # Emit a diagnostic record targeting the parameter extent.
                    [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                        Message = "Avoid using -Message with Write-PSFMessage. Use -String (and -StringValues if needed) for localization consistency."
                        Extent = $element.Extent
                        RuleName = 'AvoidWritePSFMessageMessageParameter'
                        Severity = 'Warning'
                        ScriptName = $FileName
                        Line = $element.Extent.StartLineNumber
                        Column = $element.Extent.StartColumnNumber
                        SuggestedCorrections = @() # Placeholder for potential auto-fix implementation
                    }
                }
            }
    }
}

Export-ModuleMember -Function AvoidWritePSFMessageMessageParameter