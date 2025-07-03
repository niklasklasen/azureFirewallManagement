function ConvertTo-RuleCollectionGroupObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$FirewallRulesFolderPath
    )

    $ruleCollectionGroupFolders = Get-ChildItem -Path $FirewallRulesFolderPath -Directory -Recurse

    $ruleCollectionGroups = @() 

    foreach ($ruleCollectionGroup in $ruleCollectionGroupFolders) {
        $RuleCollectionGroupName = $ruleCollectionGroup.Name.Split("-")[1]
        $RuleCollectionGroupPriority = $ruleCollectionGroup.Name.Split("-")[0]

        $ruleCollections = Get-ChildItem -Path $ruleCollectionGroupFolder.FullName -Filter "*.csv" -File
        $networkRuleCollections = $ruleCollections | where { $_.Name.Split("-")[1] -eq "network" }
        $applicationRuleCollections = $ruleCollections | where { $_.Name.Split("-")[1] -eq "application" }

        $ruleCollection= @()
        foreach ($networkRuleCollection in $networkRuleCollections) {
            $rulesCsv = Import-Csv -Path $networkRuleCollections.FullName

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
                Name                = $networkRuleCollections.Name.Split("-")[3]
                RuleCollectionType = 'FirewallPolicyFilterRuleCollection'
                Priority            = $networkRuleCollection.Name.Split("-")[0]
                Action              = [PSCustomObject]@{ Type = $networkRuleCollection.Name.Split("-")[2] }
                Rules               = $rules
            }
        }

        $ruleCollectionGroup = [PSCustomObject]@{
            Name       = $RuleCollectionGroupName
            Properties = [PSCustomObject]@{
                Priority         = $RuleCollectionGroupPriority
                RuleCollections  = $ruleCollection
            }
        }

        $ruleCollectionGroups += $ruleCollectionGroup
    }

    return $ruleCollectionGroups
}
