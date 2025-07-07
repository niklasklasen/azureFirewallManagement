function ConvertTo-RuleCollectionGroupObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$FirewallRulesFolderPath
    )
    Write-Host "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S%Z")] INFO: Getting firewall rules folder from path: $FirewallRulesFolderPath"
    $ruleCollectionGroupFolders = Get-ChildItem -Path $FirewallRulesFolderPath -Directory -Recurse

    $ruleCollectionGroups = @() 
    foreach ($ruleCollectionGroup in $ruleCollectionGroupFolders) {
        $RuleCollectionGroupName = $ruleCollectionGroup.Name.Split("-")[1]
        $RuleCollectionGroupPriority = $ruleCollectionGroup.Name.Split("-")[0]
        
        Write-Host "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S%Z")] INFO: Creating rule collection group: $ruleCollectionGroupName"
        
        $ruleCollections = Get-ChildItem -Path $ruleCollectionGroup.FullName -Filter "*.csv" -File
        $networkRuleCollections = $ruleCollections | where { $_.Name.Split("-")[1] -eq "network" }
        $applicationRuleCollections = $ruleCollections | where { $_.Name.Split("-")[1] -eq "application" }

        $ruleCollection= @()
        foreach ($networkRuleCollection in $networkRuleCollections) {
            Write-Host "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S%Z")] INFO: Creating rule collection $($networkRuleCollection.Name) to rule collection group $RuleCollectionGroupName"
            $rulesCsv = Import-Csv -Path $networkRuleCollection.FullName

            $rules = @()
            $rules += $rulesCsv | ForEach-Object {
                [PSCustomObject]@{
                    RuleType            = 'NetworkRule'
                    Name                = $_.Name
                    Description         = $_.Description
                    SourceAddresses     = $_.Source -split ';'
                    DestinationAddresses = $_.Destination -split ';'
                    DestinationPorts    = $_.Port -split ';'
                    IpProtocols         = $_.Protocol -split ';'
                }
            }
            $ruleCollection += [PSCustomObject]@{
                Name                = $networkRuleCollection.Name.Split("-")[3]
                RuleCollectionType = 'FirewallPolicyFilterRuleCollection'
                Priority            = $networkRuleCollection.Name.Split("-")[0]
                Action              = [PSCustomObject]@{ Type = $networkRuleCollection.Name.Split("-")[2] }
                Rules               = $rules
            }
            Write-Host "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S%Z")] INFO: Rule collection $($networkRuleCollection.Name) added to rule collection group $RuleCollectionGroupName"
        }

        $ruleCollectionGroup = [PSCustomObject]@{
            Name       = $RuleCollectionGroupName
            Properties = [PSCustomObject]@{
                Priority         = $RuleCollectionGroupPriority
                RuleCollections  = $ruleCollection
            }
        }

        $ruleCollectionGroups += $ruleCollectionGroup

        Write-Host "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S%Z")] INFO: Rule collection group: $ruleCollectionGroupName created"
    }

    Write-Host "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S%Z")] INFO: Rule collection groups created"
    return $ruleCollectionGroups
}
