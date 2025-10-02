function Get-DSDetectionRule {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [PsfFile] $Path,

        [string[]] $RuleType,

        [ValidateSet('File', 'Log')]
        [string[]] $SourceType,

        [switch] $IncludeInactive
    )

    process {
        if (-not (Test-Path -LiteralPath $Path)) {
            Write-PSFMessage -Level Error -Message "Fichier introuvable: $Path" -Tag DS, Detection
            return
        }

        try { $config = Import-PSFJson -Path $Path }
        catch {
            Write-PSFMessage -Level Error -Message "Echec lecture JSON '$Path' : $($_.Exception.Message)" -Tag DS, Detection
            return
        }

        if (-not $config -or -not $config.DetectionRules) { return }

        $rules = @($config.DetectionRules)

        if (-not $IncludeInactive) {
            $rules = $rules | Where-Object { $_.IsActive -eq $true }
            if (-not $rules) { return }
        }

        if ($RuleType) {
            $want = $RuleType | ForEach-Object { $_.ToLowerInvariant() }
            $rules = $rules | Where-Object { ($_.Type -as [string]).ToLowerInvariant() -in $want }
            if (-not $rules) { return }
        }

        $filtered = if ($SourceType) {
            $srcSet = @{}
            $SourceType | ForEach-Object { $srcSet[$_] = $true }
            foreach ($r in $rules) {
                $applies = @()
                foreach ($a in @($r.AppliesTo)) {
                    if ($null -eq $a) { continue }
                    if ($a.SourceType -and $srcSet.ContainsKey($a.SourceType)) { $applies += $a }
                }
                if ($applies.Count) {
                    [PSCustomObject]@{
                        Name       = [string]$r.Name
                        Type       = [string]$r.Type
                        Definition = [string]$r.Definition
                        IsActive   = [bool]$r.IsActive
                        AppliesTo  = $applies
                    }
                }
            }
        }
        else {
            $rules
        }

        if (-not $filtered) { return }

        $byKey = @{}
        foreach ($r in $filtered) {
            $key = ('{0}|{1}' -f $r.Name, $r.Type)
            if (-not $byKey.ContainsKey($key)) {
                $byKey[$key] = [PSCustomObject]@{
                    Name       = $r.Name
                    Type       = $r.Type
                    Definition = $r.Definition
                    IsActive   = [bool]$r.IsActive
                    AppliesTo  = @()
                }
            }
            foreach ($a in @($r.AppliesTo)) {
                if ($null -eq $a) { continue }
                $exists = $byKey[$key].AppliesTo | Where-Object {
                    $_.SourceType -eq $a.SourceType -and $_.SourceFilter -eq $a.SourceFilter
                }
                if (-not $exists) { $byKey[$key].AppliesTo += $a }
            }
        }

        $byKey.Keys | Sort-Object | ForEach-Object {
            $o = $byKey[$_]
            $o.AppliesTo = @($o.AppliesTo | Sort-Object SourceType, SourceFilter)
            $o
        }
    }
}
