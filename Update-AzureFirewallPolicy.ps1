
Write-Host "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S%Z")] INFO: Running 'Update-AzureFirewallPolicy.ps1'..."
Write-Host ""

# Import & Install Modules
if ([bool](Get-Module -Name module.afwManagement -ErrorAction SilentlyContinue)) { Remove-Module -Name module.afwManagement }
Import-Module ".\module.afwManagement"