using namespace System.Net
param($Request, $TriggerMetadata)
. .\GenericFunctions.ps1

$TenantID = $Request.Body.TenantID
$APIKey = $Request.body.APIKey

try{
#Check API Key.
#Compare tenantID to cosmosdb database. Grab all accounts in cosmosdb
#Get all local type accounts with status 'New'
#Return Object to client so it can create accounts.
New-output -ReturnedBody "Success"
}
catch {
  Add-Content -path $ENV:ErrorLog -Value "$($currentUTCtime): Could not create new O365 JIT Account. Error:  $($_.Exception.Message)" -Force
  New-output -ReturnedBody "Group Add Failure: $($_.Exception.Message)"
  break
}

