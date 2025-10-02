function Add-ToFileInventory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $ResolvedTarget,

        [Parameter(Mandatory = $true)]
        [string]
        $Name,

        [Parameter(Mandatory = $false)]
        [string]
        $Extension,

        [Parameter(Mandatory = $true)]
        [string]
        $Size
    )

    process {
        if (-not $script:FileInventory) {
            $script:FileInventory = @{ }
        }

        if ([string]::IsNullOrWhiteSpace($Extension)) {
            Write-PSFMessage -Module DataSanitizer -Level Warning -Message "File '$ResolvedTarget' has no extension. Skipping addition." -Tag File, Inventory
            return
        }

        # List of extensions to skip from inventory (case-insensitive, always with leading dot)
        $script:invalidExtensions = @(".PNG", ".WER", ".HIV", ".ETL", ".XSL", ".IPSEC", ".WFW", ".NFO")

        $normalizedExtension = "$Extension".ToUpperInvariant()
        $isInvalidExtension = $script:invalidExtensions -and $script:invalidExtensions -contains $normalizedExtension

        $script:FileInventory[$ResolvedTarget] = [PSCustomObject]@{
            Name                = $Name
            ResolvedTarget      = $ResolvedTarget
            Extension           = $Extension
            Size                = $Size
            AnonymizationStatus = 'NotStarted'
            IsValid             = -not $isInvalidExtension
        }

        if ($script:FileInventory[$ResolvedTarget]) {
            # Write-PSFMessage -Module DataSanitizer -Level Warning -Message "File '$ResolvedTarget' is already in the inventory. Skipping addition." -Tag File, Inventory
            return
        }

        $script:FileInventory[$ResolvedTarget] = [PSCustomObject]@{
            Name                = $Name
            ResolvedTarget      = $ResolvedTarget
            Extension           = $Extension
            Size                = $Size
            # Additional custom properties I need
            AnonymizationStatus = 'NotStarted'  # Example custom property
            IsValid             = $true          # Example custom property
        }
    }
}
