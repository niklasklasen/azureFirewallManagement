function ConvertTo-RuleCollectionGroupObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [int]$Priority
    )
convert
    # Create the Rule Collection Group object
    $ruleCollectionGroup = New-AzFirewallPolicyRuleCollectionGroup -Name $Name -Priority $Priority

    return $ruleCollectionGroup
}