function Add-DSDetectionRule {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'Single')]
    param(
        # Existing detection config file to modify
        [Parameter(Mandatory)]
        [PsfNewFileSingle] $Path,

        # --- Single rule mode ---
        [Parameter(ParameterSetName = 'Single')]
        [string] $Name,

        [Parameter(ParameterSetName = 'Single')]
        [ValidateSet('Regex')] # Extend with more types later (e.g., 'Kql','Dsl','Lookup')
        [string] $Type = 'Regex',

        # For Type='Regex', this is the regex pattern
        [Parameter(ParameterSetName = 'Single')]
        [string] $Definition,

        [Parameter(ParameterSetName = 'Single')]
        [bool] $IsActive = $true,

        [Parameter(ParameterSetName = 'Single')]
        [ValidateSet('Log', 'File')]
        [string] $SourceType,

        [Parameter(ParameterSetName = 'Single')]
        [string] $SourceFilter,

        # --- Object mode (prebuilt/custom rule objects) ---
        [Parameter(Mandatory, ParameterSetName = 'Object')]
        [object[]] $RuleObject
    )
    process {
        if (-not (Test-Path -LiteralPath $Path)) {
            Write-PSFMessage -Level Error -Message "Config file not found at '$Path'." -Tag DS, Detection
            return
        }

        try {
            $config = Import-PSFJson -Path $Path
            if (-not $config) {
                $config = [PSCustomObject]@{ Version = 1; DetectionRules = @() }
                Write-PSFMessage -Level Warning -Message "Config at '$Path' was empty. Initialized a new structure in-memory." -Tag DS, Detection
            }
            if (-not $config.PSObject.Properties.Match('DetectionRules')) {
                $config | Add-Member -NotePropertyName DetectionRules -NotePropertyValue @()
            }

            $newRules = @()

            switch ($PSCmdlet.ParameterSetName) {
                'Single' {
                    if ([string]::IsNullOrWhiteSpace($Name) -or
                        [string]::IsNullOrWhiteSpace($Type) -or
                        [string]::IsNullOrWhiteSpace($Definition) -or
                        [string]::IsNullOrWhiteSpace($SourceType) -or
                        [string]::IsNullOrWhiteSpace($SourceFilter)) {
                        Write-PSFMessage -Level Error -Message "Missing Name/Type/Definition/SourceType/SourceFilter for single-rule mode." -Tag DS, Detection
                        return
                    }

                    if ($Type -eq 'Regex') {
                        try { [void][regex]::new($Definition) }
                        catch {
                            Write-PSFMessage -Level Error -Message "Regex compile failed for '$Name': $($_.Exception.Message)" -Tag DS, Detection
                            return
                        }
                    }

                    $newRules += [PSCustomObject]@{
                        Name       = $Name.Trim()
                        Type       = $Type
                        Definition = $Definition
                        IsActive   = [bool]$IsActive
                        AppliesTo  = @([PSCustomObject]@{
                                SourceType   = $SourceType
                                SourceFilter = $SourceFilter
                            })
                    }
                }

                'Object' {
                    foreach ($obj in $RuleObject) {
                        if ($null -ne $obj.Name -and
                            $null -ne $obj.Type -and
                            $null -ne $obj.Definition -and
                            $null -ne $obj.AppliesTo) {

                            if ($obj.Type -eq 'Regex') {
                                try { [void][regex]::new([string]$obj.Definition) }
                                catch {
                                    Write-PSFMessage -Level Warning -Message "Regex compile failed for '$($obj.Name)'. Skipping. Error: $($_.Exception.Message)" -Tag DS, Detection
                                    continue
                                }
                            }

                            $applies = @()
                            foreach ($a in @($obj.AppliesTo)) {
                                if ($a.SourceType -and $a.SourceFilter) { $applies += $a }
                            }
                            if (-not $applies.Count) {
                                Write-PSFMessage -Level Warning -Message "Rule '$($obj.Name)' has no valid AppliesTo entries. Skipping." -Tag DS, Detection
                                continue
                            }

                            $newRules += [PSCustomObject]@{
                                Name       = [string]$obj.Name
                                Type       = [string]$obj.Type
                                Definition = [string]$obj.Definition
                                IsActive   = [bool]($obj.IsActive -as [bool] -or $true)
                                AppliesTo  = $applies
                            }
                        }
                        else {
                            Write-PSFMessage -Level Warning -Message "Skipped invalid rule object (needs Name/Type/Definition/AppliesTo)." -Tag DS, Detection
                        }
                    }
                }
            }

            if (-not $newRules.Count) {
                Write-PSFMessage -Level Warning -Message "No valid detection rules to add." -Tag DS, Detection
                return
            }

            $existingKeys = @{}
            foreach ($r in @($config.DetectionRules)) {
                $key = ('{0}|{1}' -f $r.Name, $r.Type)
                $existingKeys[$key] = $true
            }

            $toAdd = @()
            $skipped = @()
            foreach ($r in $newRules) {
                $key = ('{0}|{1}' -f $r.Name, $r.Type)
                if ($existingKeys.ContainsKey($key)) {
                    $skipped += $r
                }
                else {
                    $existingKeys[$key] = $true
                    $toAdd += $r
                }
            }

            foreach ($s in $skipped) {
                Write-PSFMessage -Level Warning -Message "Rule '$($s.Name)' (Type '$($s.Type)') already exists. Skipping." -Tag DS, Detection
            }

            if ($toAdd.Count -eq 0) {
                Write-PSFMessage -Level Verbose -Message "Nothing new to add after de-duplication." -Tag DS, Detection
                return
            }

            $config.DetectionRules += $toAdd

            if ($PSCmdlet.ShouldProcess($Path, "Append $($toAdd.Count) detection rule(s)")) {
                Export-PSFJson -InputObject $config -Path $Path -Encoding UTF8 -Depth 10
                Write-PSFMessage -Level Host -Message "Added $($toAdd.Count) detection rule(s) to '$Path'." -Tag DS, Detection
            }
        }
        catch {
            Write-PSFMessage -Level Error -Message "Failed to update '$Path'. $_" -Tag DS, Detection
        }
    }
}
