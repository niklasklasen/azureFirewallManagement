
Write-Host "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S%Z")] INFO: Running 'Update-AzureFirewall.ps1'..."
Write-Host ""

# Import & Install Modules
Install-Module -Name powershell-yaml -AllowClobber -Force
if ([bool](Get-Module -Name Onevinn.Deploy -ErrorAction SilentlyContinue)) { Remove-Module -Name Onevinn.Deploy }
Import-Module ".\src\Modules\Onevinn.Deploy"