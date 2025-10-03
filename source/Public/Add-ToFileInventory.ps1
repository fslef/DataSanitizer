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
            Write-PSFMessage -Module DataSanitizer -Level Verbose -Message "File '$ResolvedTarget' has no extension. Skipping addition." -Tag File, Inventory
            return
        }

        # List of valid extensions (case-insensitive, always with leading dot)
        # If extension is not in this list, it will be considered invalid
        $script:validExtensions = @(".TXT", ".LOG", ".CSV", ".JSON", ".XML", ".HTML", ".HTM", ".MD", ".RTF")

        $normalizedExtension = "$Extension".ToUpperInvariant()
        $isValidExtension = $script:validExtensions -and $script:validExtensions -contains $normalizedExtension

        # Avoid duplicating an entry: if the path is already in the inventory, skip adding it again
        if ($script:FileInventory.ContainsKey($ResolvedTarget)) {
            # Write-PSFMessage -Module DataSanitizer -Level Warning -Message "File '$ResolvedTarget' is already in the inventory. Skipping addition." -Tag File, Inventory
            return
        }

        # Create a new entry.  Include a Findings property initialized to an empty array so
        # downstream processing can append results directly.  The IsValid flag is determined
        # by the extension filter above (true if extension is in the valid list).
        $script:FileInventory[$ResolvedTarget] = [PSCustomObject]@{
            Name                = $Name
            ResolvedTarget      = $ResolvedTarget
            Extension           = $Extension
            Size                = $Size
            AnonymizationStatus = 'NotStarted'
            IsValid             = $isValidExtension
            Findings            = @()
        }
    }
}
