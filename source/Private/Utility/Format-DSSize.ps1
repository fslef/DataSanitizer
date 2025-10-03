function Format-DSSize {
    <#
        .SYNOPSIS
            Return a human-readable size string for a byte value (Private helper)
        .DESCRIPTION
            Converts a numeric byte size into a formatted string using the largest unit (KB, MB, GB) with 2 decimals.
        .PARAMETER Bytes
            The size in bytes.
        .EXAMPLE
            Format-DSSize -Bytes 1536
            Returns: 1.50 KB
        .NOTES
            Internal helper for reporting inventory statistics. Not exported.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [long]$Bytes
    )
    process {
        if ($Bytes -ge 1GB) { return ('{0:N2} GB' -f ($Bytes / 1GB)) }
        if ($Bytes -ge 1MB) { return ('{0:N2} MB' -f ($Bytes / 1MB)) }
        if ($Bytes -ge 1KB) { return ('{0:N2} KB' -f ($Bytes / 1KB)) }
        return "$Bytes B"

        write-psfmessage -Level Verbose -Message "Format-DSSize"

    }
}
