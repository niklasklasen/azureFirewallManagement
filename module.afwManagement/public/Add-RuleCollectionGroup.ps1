function Add-RuleCollectionGroup {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$RuleCollectionGroupName
    )

    # Authenticate to Azure
    Write-Host "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S%Z")] INFO: Authenticating to Azure..."
    $header = Get-AccessToken -Scope ARM
    if (-not $header) {
        throw "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S%Z")] ERROR: Failed to authenticate to Azure. Please check your credentials."
    }

    

}