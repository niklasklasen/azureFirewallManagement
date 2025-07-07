
Write-Host "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S%Z")] INFO: Running 'Update-AzureFirewallPolicy.ps1'..."
Write-Host ""

# Import & Install Modules
if ([bool](Get-Module -Name module.afwManagement -ErrorAction SilentlyContinue)) { Remove-Module -Name module.afwManagement }
Import-Module ".\module.afwManagement"


# Logic to ingest CSV Files and Folders
$ruleCollectionGroups = ConvertTo-RuleCollectionGroupObject -FirewallRulesFolderPath ./firewall-rules
# Loop per folder to build Rule Collection Groups
# Function with logic to build Rule Collection Group Object
# Logic to deploy Rule Collection Groups

# Function to build summarized CSV file
$ruleCollectionGroups | ConvertTo-Json -Depth 10 | Out-File -FilePath ./firewall-rules/rulecollectionobject.json -Encoding utf8 -Force