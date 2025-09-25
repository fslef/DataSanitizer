function Format-WordWrap {
    <#
    .SYNOPSIS
        Wraps text to fit within a specified width while preserving word boundaries.
    .DESCRIPTION
        This function takes a text message and wraps it to fit within the specified width,
        ensuring that words are not broken across lines. It handles edge cases like
        empty strings, very long words, and narrow widths.
    .PARAMETER Message
        The text message to be wrapped.
    .PARAMETER Width
        The maximum width for each line. Must be greater than 0.
    .EXAMPLE
        Format-WordWrap -Message "This is a long message that needs wrapping" -Width 20
    .EXAMPLE
        Format-WordWrap -Message "Short" -Width 100
    .NOTES
        - Empty or whitespace-only messages return a single empty line
        - Words longer than the width are placed on their own line
        - Multiple consecutive spaces are preserved
        - Width must be at least 1
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$Message,
        
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$Width
    )
    
    # Handle empty or whitespace-only messages
    if ([string]::IsNullOrWhiteSpace($Message)) {
        return @('')
    }
    
    # Split message into words, preserving whitespace structure
    $words = $Message -split '\s+'
    
    $wrappedLines = @()
    $currentLine = ''
    
    foreach ($word in $words) {
        # Skip empty words (from multiple spaces)
        if ([string]::IsNullOrEmpty($word)) {
            continue
        }
        
        # Calculate space needed (space before word if line has content)
        $spaceNeeded = if ($currentLine.Length -gt 0) { 1 } else { 0 }
        
        # Check if word fits on current line
        if (($currentLine.Length + $spaceNeeded + $word.Length) -le $Width) {
            # Word fits on current line
            if ($currentLine.Length -gt 0) {
                $currentLine += ' ' + $word
            } else {
                $currentLine = $word
            }
        } else {
            # Word doesn't fit, start new line
            if ($currentLine) { 
                $wrappedLines += $currentLine 
            }
            $currentLine = $word
        }
    }
    
    # Add the last line if it contains content
    if ($currentLine) { $wrappedLines += $currentLine }
    
    # Ensure we always return at least one line (empty if no content)
    if ($wrappedLines.Count -eq 0) {
        $wrappedLines = @('')
    }
    
    # Always return as array - PowerShell's comma operator should prevent unwrapping
    return ,([string[]]$wrappedLines)
}