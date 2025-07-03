
Write-Host "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S%Z")] INFO: Running 'Update-AzureFirewallPolicy.ps1'..."
Write-Host ""

# Import & Install Modules
if ([bool](Get-Module -Name module.afwManagement -ErrorAction SilentlyContinue)) { Remove-Module -Name module.afwManagement }
Import-Module ".\module.afwManagement"


# Logic to ingest CSV Files and Folders

# Loop per folder to build Rule Collection Groups
# Function with logic to build Rule Collection Group Object
# Logic to deploy Rule Collection Groups



Add-AzureFirewallPolicy -SubscriptionId "277fa68f-7cba-4e42-8f33-489df4796855" -ResourceGroupName "afw-rg" -FirewallPolicyName "afw-afwp-v2" -Location "swedencentral"