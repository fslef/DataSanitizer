function Start-DSFileDetection {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [PsfLiteralpathSingle]$InputPath
    )

    process {

        Write-PSFMessage -Module DataSanitizer -Level Important -String 'Start-DSFileDetection.Start' -StringValues $InputPath

        # Determine if the path is a file or a directory
        if (Test-Path -Path $InputPath -PathType Container) {
            Write-PSFMessage -Module DataSanitizer -Level Verbose -String 'Start-DSFileDetection.StartingFolder' -StringValues $InputPath
            # NOTE : Code for a folder input path
        }
        else {
            Write-PSFMessage -Module DataSanitizer -Level Verbose -String 'Start-DSFileDetection.StartingFile' -StringValues $InputPath
            # NOTE : Code for a file input path
        }
    }
}
