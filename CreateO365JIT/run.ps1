using namespace System.Net
param($Request, $TriggerMetadata)
function New-output ($ReturnedBody) {
  Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
      StatusCode  = [HttpStatusCode]::OK
      Body        = $ReturnedBody
      ContentType = 'text/json'
    }) 
}
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
  Add-Content -path $ENV:ErrorLog -Value "$($currentUTCtime): Could not create new O365 JIT Account. Error:  $($_.Exception.Message)" -Force
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
#New-Output -ReturnedBody $Body
  $CreateUserResult = Invoke-RestMethod -Uri 'https://graph.microsoft.com/v1.0/users' -ContentType 'Application/json' -Method POST -Body $CreateBody -Headers $Headers
}
catch {
  Add-Content -path $ENV:ErrorLog -Value "$($currentUTCtime): Could not create new O365 JIT Account. Error:  $($_.Exception.Message)" -Force
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

#New-AccountTrace -AccountID $($CreateUserResult.id) -ExpectedGroups $AddGroupResult.id
New-output -ReturnedBody "Success"
}
catch {
  break
  Add-Content -path $ENV:ErrorLog -Value "$($currentUTCtime): Could not create new O365 JIT Account. Error:  $($_.Exception.Message)" -Force
  New-output -ReturnedBody "Group Add Failure: $($_.Exception.Message)"
}

