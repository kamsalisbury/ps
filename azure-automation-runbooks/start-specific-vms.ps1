# An array of VMs to start
$targets = @("vm1","vm2","vm3")
# Specify the resource group containing the targets
$rg = 'My Resource Group'
# It is wise to store the following variables encrypted in the automation account. The Name parameter has to match the stored automation account variable
$subscription = (Get-AutomationVariable -Name 'AzSubId')
$tenant = (Get-AutomationVariable -Name 'AzTenantId')
$environment = (Get-AutomationVariable -Name 'Environment')

# Use the default AzureRunAsConnection, the RunAs account created by the automation account
$connectionName = "AzureRunAsConnection"
# Now use the default AzureRunAsConnection
try {
    # Specify how the following cmdlet will authenticate to the Azure environment
    $spConnection = Get-AutomationConnection -Name $connectionName
    "Logging into Azure..."
    # Do certificate authentication using the certificate belonging to the AzureRunAsConnection
    $account = Add-AzAccount -ServicePrincipal -TenantId $spConnection.TenantId -ApplicationId $spConnection.ApplicationId -CertificateThumbprint $spConnection.CertificateThumbprint -Environment $environment
}
catch {
    if ($spConnection) {
        $errorMessage = "Connection $connectionName not found. Check Azure RunAs account."
        throw $errorMessage
    } else {
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}

# Start the VMs specifying the verbose flag since the job log will show the data for troubleshooting and is low cost when configuring automation account diagnostic settings to log to a log analytics workspace
foreach ($vm in $targets) {
    Start-AzVm -ResourceGroup $rg -Name $vm -WarningAction:Continue -ErrorAction:Continue -Verbose
}
