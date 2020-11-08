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
    $ENV:RefreshToken = $($token.refreshtoken)
}
catch {
    Add-Content -path $ENV:ErrorLog -Value "$($currentUTCtime): Could not refresh tokens. Error:  $($_.Exception.Message)" -Force
}