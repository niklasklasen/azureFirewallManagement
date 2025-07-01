
Write-Host "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S%Z")] INFO: Running 'Update-AzureFirewallPolicy.ps1'..."
Write-Host ""

# Import & Install Modules
Install-Module -Name powershell-yaml -AllowClobber -Force
if ([bool](Get-Module -Name module.afwManagement -ErrorAction SilentlyContinue)) { Remove-Module -Name module.afwManagement }
Import-Module ".\module.afwManagement"