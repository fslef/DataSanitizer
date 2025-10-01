function New-DSDetectionConfig {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [PsfNewFileSingle] $Path,

        # If set, seed with a few common Regex rules
        [switch] $IncludeBaseline
    )

    process {

        $rules = @()
        if ($IncludeBaseline) {
            Write-PSFMessage -Level Verbose -Message "Adding baseline detection rules (Regex type)." -Tag DS, Detection
            $rules += [PSCustomObject]@{
                Name       = 'IPv4Address'
                Type       = 'Regex'
                Definition = '(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'
                IsActive   = $true
                AppliesTo  = @([PSCustomObject]@{ SourceType = 'File'; SourceFilter = '.*' })
            }
            $rules += [PSCustomObject]@{
                Name       = 'IPv6Address'
                Type       = 'Regex'
                Definition = '^(?:[A-Fa-f0-9]{1,4}:){7}[A-Fa-f0-9]{1,4}$'
                IsActive   = $true
                AppliesTo  = @([PSCustomObject]@{ SourceType = 'File'; SourceFilter = '.*' })
            }
            $rules += [PSCustomObject]@{
                Name       = 'DistinguishedName'
                Type       = 'Regex'
                Definition = '^([a-zA-Z0-9\-]+=[^,]+,?)+$'
                IsActive   = $true
                AppliesTo  = @([PSCustomObject]@{ SourceType = 'File'; SourceFilter = '.*' })
            }
            $rules += [PSCustomObject]@{
                Name       = 'GUID'
                Type       = 'Regex'
                Definition = '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$'
                IsActive   = $true
                AppliesTo  = @([PSCustomObject]@{ SourceType = 'File'; SourceFilter = '.*' })
            }
        }

        $config = [PSCustomObject]@{
            Version        = 1
            DetectionRules = $rules
        }

        if ($PSCmdlet.ShouldProcess($Path, "Write detection configuration JSON")) {
            Export-PSFJson -InputObject $config -Path $Path -Encoding UTF8 -Depth 10
            Write-PSFMessage -Level Verbose -String "New-DSDetectionConfig.Confirmation" -StringValues $Path
        }
    }

}
