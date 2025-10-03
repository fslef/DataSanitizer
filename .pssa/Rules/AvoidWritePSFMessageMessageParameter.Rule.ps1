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
        # PSScriptAnalyzer supplies FilePath; accept both for resilience.
        [Alias('FileName')]
        [string] $FilePath
    )

    # Collect all command ASTs once.
    $commands = $Ast.FindAll({ param($n) $n -is [System.Management.Automation.Language.CommandAst] }, $true)
    foreach ($command in $commands) {
        $name = $command.GetCommandName()
        if (-not $name -or $name -ine 'Write-PSFMessage') { continue }

        $hasStringParam = $false
        $flaggedViaMessageParam = $false
        $firstNonParameterElement = $null

        foreach ($element in $command.CommandElements) {
            if ($element -is [System.Management.Automation.Language.CommandParameterAst]) {
                switch -Regex ($element.ParameterName) {
                    '^String$' { $hasStringParam = $true }
                    '^Message$' {
                        $flaggedViaMessageParam = $true
                        [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                            Message              = 'Avoid using -Message with Write-PSFMessage. Use -String (and -StringValues if needed) for localization consistency.'
                            Extent               = $element.Extent
                            RuleName             = 'AvoidWritePSFMessageMessageParameter'
                            Severity             = 'Warning'
                            ScriptName           = $FilePath
                            Line                 = $element.Extent.StartLineNumber
                            Column               = $element.Extent.StartColumnNumber
                            SuggestedCorrections = @()
                        }
                    }
                }
                continue
            }

            if (-not $firstNonParameterElement) {
                $firstNonParameterElement = $element
            }
        }

        # If no -Message parameter specified but a positional string was used as first arg and -String not supplied, also flag.
        if (-not $flaggedViaMessageParam -and -not $hasStringParam -and $firstNonParameterElement -and (
                $firstNonParameterElement -is [System.Management.Automation.Language.StringConstantExpressionAst] -or
                $firstNonParameterElement -is [System.Management.Automation.Language.ExpandableStringExpressionAst])) {
            [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                Message              = 'Avoid passing a positional message to Write-PSFMessage. Use -String (with localization key) and -StringValues instead.'
                Extent               = $firstNonParameterElement.Extent
                RuleName             = 'AvoidWritePSFMessageMessageParameter'
                Severity             = 'Warning'
                ScriptName           = $FilePath
                Line                 = $firstNonParameterElement.Extent.StartLineNumber
                Column               = $firstNonParameterElement.Extent.StartColumnNumber
                SuggestedCorrections = @()
            }
        }
    }
}