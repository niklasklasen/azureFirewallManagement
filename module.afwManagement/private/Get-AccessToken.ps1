function Get-AccessToken {
    param(
        [Parameter(Mandatory=$false)]
        [string]$tenantId,
        [Parameter(Mandatory=$false)]
        [string]$clientId,
        [Parameter(Mandatory=$false)]
        [string]$clientSecret,
        [Parameter(Mandatory = $false)]
        [ValidateSet('Client','Code', IgnoreCase=$false)]
        [string]$GrantType = 'Client',
        [Parameter(Mandatory = $true)]
        [ValidateSet('ARM','Graph','LogAnalytics', IgnoreCase=$false)]
        [string]$Scope
    )

    $resource = $(
        switch ($scope) {
            ARM { 'https://management.core.windows.net' }
            Graph { 'https://graph.microsoft.com/' }
            LogAnalytics { 'https://api.loganalytics.io' }
        }
    )

    if ((-not $Global:Config) -and (-not $Global:Config.Session)) { $Global:Config = @{ Session = [PSCustomObject]@{}; } }
    if (-not $Global:Config.Session.$Scope) { Add-Member -InputObject $Global:Config.Session -MemberType NoteProperty -Name $Scope -Value $null -Force }

    $nowEpochUtc = (Get-Date -UFormat %s) - 30
    if(($Global:Config.Session."$Scope".expires_on -le $nowEpochUtc) -or ($Global:Config.Session."$Scope".resource -ne $resource)) {
        Write-Host "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S%Z")] INFO: Fetching new access token for $scope."

        if ($GrantType -eq 'Client') {
            $token = Invoke-WebRequest "https://login.microsoftonline.com/$($Global:tenantId)/oauth2/token" `
            -Method 'POST' `
            -ContentType 'application/x-www-form-urlencoded' `
            -Body @{'resource' = $resource; 'client_id' = $($Global:clientId); 'grant_type' = 'client_credentials'; 'client_secret' = $($Global:clientSecret);}
    
        } elseif ($GrantType -eq 'Code') {

        }
    

        $Global:Config.Session."$Scope" = $token.Content | ConvertFrom-Json
    } else {
        Write-Host "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S%Z")] INFO: Using old access token for $scope."
    }

    $accessToken = $Global:Config.Session."$Scope".access_token
    return @{
        'Content-Type' = 'application/json';
        Authorization  = "Bearer $($accessToken)";
    };
}
