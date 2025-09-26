function hello-world {
    [CmdletBinding()] # Enables common parameters like -Verbose, -Debug, -ErrorAction, etc.
    param()

    Clear-PSFMessage

    # Set-PSFConfig -FullName PSFramework.Message.Style.Breadcrumbs -Value $false
    # Set-PSFConfig -FullName PSFramework.Message.Style.Level -Value $false

    # Write-PSFMessage -Level Critical -Message 'This is a critical message.'
    # Write-PSFMessage -Level Important -Message 'This is an important message.'
    # Write-PSFMessage -Level Significant -Message 'This is a significant message.'
    # Write-PSFMessage -Level VeryVerbose -Message 'This is a veryverbose message.'
    # Write-PSFMessage -Level SomewhatVerbose -Message 'This is a somewhat verbose message.'
    # Write-PSFMessage -Level System -Message 'This is a system message.'
    # Write-PSFMessage -Level Debug -Message 'This is a debug message.'
    # Write-PSFMessage -Level InternalComment -Message 'This is an internal comment message.'
    # Write-PSFMessage -Level Warning -Message 'This is a warning message.'
    # Write-PSFMessage -Level Error -Message 'This is an error message.'

    # Write-PSFMessage -Level Important -Message 'This is an important message.' -Tag 'MyTag'

    # Write-PSFMessage "This is just a simple message without level."

    # Write-PSFMessage -Level Debug -Message "Executing SQL Query 'SELECT * FROM table'" -Breakpoint
    # Write-PSFMessage -Level Critical -Message "Last Message"




}
