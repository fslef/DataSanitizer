@{
    <#
        This is only required if you need to use the method PowerShellGet & PSDepend
        It is not required for PSResourceGet or ModuleFast (and will be ignored).
        See Resolve-Dependency.psd1 on how to enable methods.
    #>
    PSDependOptions                = @{
       AddToPath  = $true
       Target     = 'output\RequiredModules'
       Parameters = @{    Register-PSResourceRepository -Name PSGallery -Uri "https://www.powershellgallery.com/api/v2" -Trusted    # Remove old PSGallery repository if it exists
    Unregister-PSResourceRepository -Name PSGallery -ErrorAction SilentlyContinue

    # Register PSGallery with the correct URL and trust settings
    Register-PSResourceRepository -Name PSGallery -Uri "https://www.powershellgallery.com/api/v2" -Trusted

    # Update PowerShellGet and PSResourceGet to latest
    Install-Module PowerShellGet -Force -Scope CurrentUser
    Install-Module PSResourceGet -Force -Scope CurrentUser

    # Restart your PowerShell session here!

    # Now install your required modules
    Install-Module InvokeBuild, PSScriptAnalyzer, Pester, Plaster, ModuleBuilder, MarkdownLinkCheck, ChangelogManagement, Sampler.GitHubTasks, DscResource.Test, DscResource.AnalyzerRules, xDscResourceDesigner, PlatyPS, DscResource.DocGenerator -Scope CurrentUser -Force
           Repository = 'PSGallery'
       }
    }

    InvokeBuild                 = 'latest'
    PSScriptAnalyzer            = 'latest'
    Pester                      = 'latest'
    Plaster                     = 'latest'
    ModuleBuilder               = 'latest'
    MarkdownLinkCheck           = 'latest'
    ChangelogManagement         = 'latest'
    'Sampler.GitHubTasks'       = 'latest'
    'DscResource.Test'          = 'latest'
    'DscResource.AnalyzerRules' = 'latest'
    xDscResourceDesigner        = 'latest'
    PlatyPS                     = 'latest'
    'DscResource.DocGenerator'  = 'latest'
}