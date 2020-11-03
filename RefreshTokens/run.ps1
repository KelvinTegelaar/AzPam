# Input bindings are passed in via param block.
param($Timer)
$currentUTCtime = (get-date).ToUniversalTime()
# Write an information log with the current time.
Write-Host "PowerShell timer trigger function ran! TIME: $currentUTCtime"

$ApplicationId = $ENV:ApplicationID
$ApplicationSecret = $ENV:ApplicationSecret | Convertto-SecureString -AsPlainText -Force
$TenantID = $ENV:TenantID
$credential = New-Object System.Management.Automation.PSCredential($ApplicationId, $ApplicationSecret)
try {
    $token = New-PartnerAccessToken -ApplicationId $ApplicationID -Scopes 'https://api.partnercenter.microsoft.com/user_impersonation' -ServicePrincipal -Credential $credential -Tenant $TenantID -UseAuthorizationCode
    $Exchangetoken = New-PartnerAccessToken -ApplicationId 'a0c73c16-a7e3-4564-9a95-2bdf47383716' -Scopes 'https://outlook.office365.com/.default' -Tenant $TenantID -UseDeviceAuthentication
    $ENV:RefreshToken = $($token.refreshtoken)
    $ENV:ExchangeRefreshToken = $($ExchangeToken.Refreshtoken)
}
catch {
    Add-Content -path $ENV:ErrorLog -Value "$($currentUTCtime): Could not refresh tokens. Error:  $($_.Exception.Message)" -Force
}