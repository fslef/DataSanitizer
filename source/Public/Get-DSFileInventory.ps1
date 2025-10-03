function Get-DSFileInventory {
    <#
	.SYNOPSIS
	Returns the current DataSanitizer file inventory.

	.DESCRIPTION
	By default returns only entries where IsValid = $true. Use -IncludeInvalid to also return
	invalid entries. Use -Path to load a previously exported inventory JSON file instead of the
	in-memory session variable created during Start-DSFileDetection / Add-ToFileInventory.
	-AsHashtable returns the internal key/value structure (resolved path -> metadata object)
	rather than just the metadata objects.

	.PARAMETER IncludeInvalid
	Include invalid entries as well as valid ones (default output only shows valid items).

	.PARAMETER Path
	Path to a FileInventory.json produced by a prior run. If omitted, uses the in-memory
	$script:FileInventory created during Start-DSFileDetection/Add-ToFileInventory.

	.PARAMETER AsHashtable
	Return the hashtable form (keys = resolved target path, values = metadata objects).

	.PARAMETER Extension
	One or more file extensions to filter by. Case-insensitive. You may specify with or without
	leading dot (e.g. 'txt' or '.txt'). When supplied, only matching entries are returned.

	.OUTPUTS
	PSCustomObject (or Hashtable when -AsHashtable is used)
	#>
    [CmdletBinding()]
    [OutputType([pscustomobject], [hashtable])]
    param(
        [Parameter()] [switch] $IncludeInvalid,
        [Parameter()] [string] $Path,
        [Parameter()] [switch] $AsHashtable,
        [Parameter()] [Alias('Ext')] [string[]] $Extension
    )

    begin {
        $inventoryHashtable = $null

        if ($Path) {
            if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
                Write-Verbose "Inventory file not found: $Path"
                $inventoryHashtable = @{}
            }
            else {
                try {
                    $loaded = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json -ErrorAction Stop
                    # Build hashtable keyed by resolved target; ignore duplicates.
                    $inventoryHashtable = @{}
                    foreach ($item in $loaded) {
                        if ($null -ne $item.ResolvedTarget -and -not $inventoryHashtable.ContainsKey($item.ResolvedTarget)) {
                            $inventoryHashtable[$item.ResolvedTarget] = $item
                        }
                    }
                }
                catch {
                    Write-Verbose "Failed to load inventory from $Path : $($_.Exception.Message)"
                    $inventoryHashtable = @{}
                }
            }
        }
        elseif ($script:FileInventory) {
            $inventoryHashtable = $script:FileInventory
        }
        else {
            $inventoryHashtable = @{}
        }
    }
    process {
        # If nothing to return, output empty collection (predictable, pipeline friendly)
        if (-not $inventoryHashtable.Count) { return @() }

        if ($AsHashtable) {
            if ($IncludeInvalid) { return $inventoryHashtable }
            $filtered = @{}
            foreach ($entry in $inventoryHashtable.GetEnumerator()) {
                if ($entry.Value.IsValid) { $filtered[$entry.Key] = $entry.Value }
            }
            return $filtered
        }

        $items = $inventoryHashtable.GetEnumerator() | ForEach-Object { $_.Value }
        if (-not $IncludeInvalid) { $items = $items | Where-Object IsValid }

        if ($Extension) {
            # Normalize extensions once (upper + ensure leading dot) for faster matching
            $normalizedExt = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
            foreach ($ext in $Extension) {
                if ([string]::IsNullOrWhiteSpace($ext)) { continue }
                $e = if ($ext.StartsWith('.')) { $ext } else { '.{0}' -f $ext }
                $null = $normalizedExt.Add($e)
            }
            if ($normalizedExt.Count -gt 0) {
                $items = $items | Where-Object { $normalizedExt.Contains($_.Extension) }
            }
        }
        $items
    }
}

