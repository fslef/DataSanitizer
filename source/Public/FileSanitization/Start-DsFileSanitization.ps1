function Start-DsFileSanitization {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [PsfFileSingle]$InventoryPath = (Join-Path -Path (Get-PSFConfig -Module DataSanitizer -Name Path.DSIncidentFolder).Value -ChildPath 'Inventory.json'),

        [Parameter(Mandatory = $true)]
        [PsfFileSingle]$FindingsFilePath
    )

    begin {}
    process {
        # Load files to process from inventory

        $MaxThreads = 5

        $AllFiles = Import-PSFJson -Path $InventoryPath
        $FilesToProcess = $AllFiles.Valid | Where-Object { -not $_.Processed }

        Write-PSFMessage -Module DataSanitizer -Level Important -Message "Parallel processing of {0} files with {1} parallel threads" -StringValues $FilesToProcess.Count, $MaxThreads

        # $Findings = Import-Csv -Path $FindingsFilePath -Delimiter ";" -Encoding utf8
        $variables = @{
            Findings = Import-Csv -Path $FindingsFilePath -Delimiter ";" -Encoding utf8
        }
        # ------

        # Create Workflow
        $workflow = New-PSFRunspaceWorkflow -Name 'ExampleWorkflow'

        # Add Workers

        $workflow | Add-PSFRunspaceWorker -Name Processing -InQueue Input -OutQueue Done -Count $MaxThreads -ScriptBlock {
            # Inside the worker the queued object is available as $_ (or $PSItem)
            if (-not $Findings) {
                Write-PSFMessage -Module DataSanitizer -Level Warning -Message 'Findings variable not populated in worker.'
            }

            Write-PSFMessage -Module DataSanitizer -Level Verbose -Message "Processing {0} against {1} findings" -StringValues (Split-Path -Path $_.FilePath -Leaf), ($Findings.Count)

            [PSCustomObject]@{
                FilePath = $_.FilePath
                Status   = 'Completed'
                Result   = $null
            }
        } -Variables $Variables -CloseOutQueue

        # Add input
        $workflow | Write-PSFRunspaceQueue -Name Input -BulkValues $FilesToProcess -Close

        # Start Workflow
        $workflow | Start-PSFRunspaceWorkflow

        # Wait for Workflow to complete and stop it
        $workflow | Wait-PSFRunspaceWorkflow -WorkerName Processing -Close -PassThru | Stop-PSFRunspaceWorkflow

        # Retrieve results
        $results = $workflow | Read-PSFRunspaceQueue -Name Done -All

        # Final Cleanup
        $workflow | Remove-PSFRunspaceWorkflow

    }

}
