@{
    Severity            = @(
        'Error'
        'Warning'
        'Information'
    )

    IncludeDefaultRules = $true

    # Prefer defaults; only exclude what you don’t want.
    ExcludeRules        = @(
        # Example: 'PSUseDeclaredVarsMoreThanAssignments'
    )

    Rules               = @{
        PSAlignAssignmentStatement              = @{
            Enable         = $true
            CheckHashtable = $true
        }

        PSUseConsistentIndentation              = @{
            Enable              = $true
            IndentationSize     = 4
            PipelineIndentation = 'IncreaseIndentationForFirstPipeline'
            Kind                = 'space'
        }

        PSUseConsistentWhitespace               = @{
            Enable                                  = $true
            CheckInnerBrace                         = $true
            CheckOpenBrace                          = $false
            CheckOpenParen                          = $false
            CheckOperator                           = $false
            CheckPipe                               = $true
            CheckPipeForRedundantWhitespace         = $false
            CheckSeparator                          = $true
            CheckParameter                          = $false
            IgnoreAssignmentOperatorInsideHashTable = $false
        }

        PSAvoidSemicolonsAsLineTerminators      = @{
            Enable = $true
        }

        PSPlaceCloseBrace                       = @{
            Enable             = $true
            NoEmptyLineBefore  = $false
            IgnoreOneLineBlock = $true
            NewLineAfter       = $true
        }

        PSPlaceOpenBrace                        = @{
            Enable             = $true
            OnSameLine         = $true
            NewLineAfter       = $true
            IgnoreOneLineBlock = $true
        }

        # Compatibility checks (PowerShell 5.1)
        # For PSUseCompatibleCommands and PSUseCompatibleTypes the newer engine
        # requires TargetProfiles (list of platform profile names or json paths),
        # NOT TargetVersions. Using TargetVersions caused the runtime error
        # "TargetProfiles cannot be empty" because those rules expect at least
        # one profile entry. We target Windows PowerShell 5.1 on Windows 10 Pro.
        PSUseCompatibleCommands                 = @{
            Enable         = $true
            TargetProfiles = @(
                'win-48_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework'
            )
        }
        PSUseCompatibleSyntax                   = @{
            Enable         = $true
            TargetVersions = @('5.1')
        }
        PSUseCompatibleTypes                    = @{
            Enable         = $true
            TargetProfiles = @(
                'win-48_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework'
            )
        }

        # Additional correctness/safety rules
        PSAvoidUsingCmdletAliases               = @{ Enable = $true }
        PSAvoidUsingPlainTextForPassword        = @{ Enable = $true }
        MisleadingBacktick                      = @{ Enable = $true }
        AvoidTrailingWhitespace                 = @{ Enable = $true }
        AvoidUsingDoubleQuotesForConstantString = @{ Enable = $true }
        UseCorrectCasing                        = @{ Enable = $true }
    }
}