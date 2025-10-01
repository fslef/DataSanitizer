function Get-DSConfig {

    [CmdletBinding()]
    param()

    Get-PSFConfig -Module DataSanitizer

    Get-PSFConfig -Module PSFramework -Name *Language
}
