using namespace System.Net
param($Request, $TriggerMetadata)
. .\GenericFunctions.ps1
$Filter = $Request.Body.Filter

try {
#Get all accounts in database based on filter in query.
}
catch {
  Add-Content -path $ENV:ErrorLog -Value "$($currentUTCtime): Could not create new O365 JIT Account. Error:  $($_.Exception.Message)" -Force
  New-output -ReturnedBody "Group Add Failure: $($_.Exception.Message)"
  break
}

