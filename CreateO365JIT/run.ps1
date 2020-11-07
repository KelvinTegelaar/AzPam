using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

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
  
  $Body = [PSCustomObject]@{
    "accountEnabled"    = $true
    "displayName"       = $Account['Displayname']
    "mailNickname"      = $Account['mail']
    "userPrincipalName" = $account['UPN']
    "passwordProfile"   = @{
      "forceChangePasswordNextSignIn" = $false
      "password"                      = $Account['password']
    }
  } | ConvertTo-Json

  $CreateUserResult = Invoke-RestMethod -Uri 'https://graph.microsoft.com/v1.0/users' -Method POST -Body $Body -Headers $Headers
  $GroupBody = [PSCustomObject]@{
    principalId      = $CreateUserResult.UserID
    roleDefinitionId = $Account['roleDefinitionId']
    directoryScopeId = "/"
  } 
  
  $AddGroupResult = Invoke-RestMethod -Uri 'https://graph.microsoft.com/beta/roleManagement/directory/roleAssignments' -Method POST -Body $GroupBody -Headers $Headers

  #New-AccountTrace -AccountID $($CreateUserResult.id) -ExpectedGroups $AddGroupResult.id
  $ReturnedBody = "success"
}
catch {
  Add-Content -path $ENV:ErrorLog -Value "$($currentUTCtime): Could not create new O365 JIT Account. Error:  $($_.Exception.Message)" -Force
  $ReturnedBody = 'failure'
}

# Interact with query parameters or the body of the request.
# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode  = [HttpStatusCode]::OK
    Body        = $ReturnedBody
    ContentType = 'text/html'
  }) 
  
