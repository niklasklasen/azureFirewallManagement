function Add-AzureFirewallPolicy {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $true)]
        [string]$FirewallPolicyName,

        [Parameter(Mandatory = $true)]
        [string]$Location, 

        [Parameter(Mandatory = $true)]
        [string]$SubscriptionId
    )

    $apiVersion = "2024-05-01"

    # Authenticate to Azure
    Write-Host "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S%Z")] INFO: Authenticating to Azure..."
    $header = Get-AzAccessToken -scope ARM
    if (-not $header) {
        throw "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S%Z")] ERROR: Failed to authenticate to Azure. Please check your credentials."
    }

    Write-Host "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S%Z")] INFO: Creating Azure Firewall Policy"
    Invoke-WebRequest -Uri "https://management.azure.com/subscriptions/${SubscriptionId}/resourceGroups/${ResourceGroupName}/providers/Microsoft.Network/firewallPolicies/${FirewallPolicyName}?api-version=${apiVersion}" `
        -Method 'PUT' `
        -Headers $header `
        -Body (@{ location = $Location } | ConvertTo-Json) `
        -ContentType 'application/json' `
        -ErrorAction Stop
}