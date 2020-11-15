using namespace System.Net
param($Request, $TriggerMetadata)
. .\GenericFunctions.ps1
# Input bindings are passed in via param block.

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."
$Account = [System.Web.HttpUtility]::ParseQueryString($Request.Body)

try {
  $Authbody = @{
    'resource'      = 'https://graph.microsoft.com'
    'client_id'     = $ENV:ApplicationId
    'client_secret' = $ENV:ApplicationSecret
    'grant_type'    = "client_credentials"
    'scope'         = "openid"
  }
  $ClientToken = Invoke-RestMethod -Method post -Uri "https://login.microsoftonline.com/$($Account['tenantid'])/oauth2/token" -Body $Authbody -ErrorAction Stop
  $headers = @{ "Authorization" = "Bearer $($ClientToken.access_token)" }
}
catch {
  Write-AzPAMLogTable -type "Error" -Message "Could not login to Azure Graph. Error:  $($_.Exception.Message)" -SourceAccount "SYSTEM"
  New-output -ReturnedBody "Graph Login Failure: $($_.Exception.Message)"
  break
}

try {
  $CreateBody = [PSCustomObject]@{
    "accountEnabled"    = $true
    "displayName"       = $Account['displayname']
    "mailNickname"      = $Account['mail']
    "userPrincipalName" = $account['UPN']
    "passwordProfile"   = @{
      "forceChangePasswordNextSignIn" = $false
      "password"                      = $Account['password']
    }
  } | ConvertTo-Json
  $CreateUserResult = Invoke-RestMethod -Uri 'https://graph.microsoft.com/v1.0/users' -ContentType 'Application/json' -Method POST -Body $CreateBody -Headers $Headers
}
catch {
  Write-AzPAMLogTable -type "Error" -Message "Could not add user. Error:  $($_.Exception.Message)" -SourceAccount "SYSTEM" -AzPAMID $AzPAMID
  New-output -ReturnedBody "User Add Failure: $($_.Exception.Message)"
  break
}

try{
$GroupBody = [PSCustomObject]@{
  principalId      = $CreateUserResult.ID
  roleDefinitionId = $Account['roleDefinitionId']
  directoryScopeId = "/"
} | ConvertTo-Json
  
$AddGroupResult = Invoke-RestMethod -Uri 'https://graph.microsoft.com/beta/roleManagement/directory/roleAssignments' -Method POST -ContentType 'Application/json' -Body $GroupBody -Headers $Headers

#New-AccountTrace -AccountID $($CreateUserResult.id) -ExpectedGroups $AddGroupResult.id -AccountInfo  -Displayname $Account['displayname'] -mailNickname $Account['mail'] -userPrincipalName $account['UPN']
New-output -ReturnedBody "Success"
}
catch {
  Write-AzPAMLogTable -type "Error" -Message "Could not add account to group. Error:  $($_.Exception.Message)" -SourceAccount "SYSTEM"
  New-output -ReturnedBody "Group Add Failure: $($_.Exception.Message)"
  break
}

