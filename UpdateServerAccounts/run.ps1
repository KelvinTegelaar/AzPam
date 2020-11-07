using namespace System.Net
param($Request, $TriggerMetadata)
function New-output ($ReturnedBody) {
  Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
      StatusCode  = [HttpStatusCode]::OK
      Body        = $ReturnedBody
      ContentType = 'text/json'
    }) 
}

$TenantID = $Request.Body.TenantID
$APIKey = $Request.body.APIKey
$Users = $Request.Body.Users

#$users should be all users with attribute AzPAM set.
#Check API Key.
#Compare tenantID to cosmosdb database. Grab all accounts in cosmosdb
try {
  foreach ($User in $users) {
    #Update account in cosmosdb if status was 'new'
    #log lassed loggedon date
    #Compare if more info is changed, e.g. someone elevated groups, changed permissions or expiry date. 
    New-output -ReturnedBody "Success"

  }
}
catch {
  Add-Content -path $ENV:ErrorLog -Value "$($currentUTCtime): Could not create new O365 JIT Account. Error:  $($_.Exception.Message)" -Force
  New-output -ReturnedBody "Group Add Failure: $($_.Exception.Message)"
  break
}

