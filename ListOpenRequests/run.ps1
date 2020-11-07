using namespace System.Net
param($Request, $TriggerMetadata)
. .\GenericFunctions.ps1


try {
#Get all request in database with state New,Active,Denied,Reviewed. Return requests HTML as a table. nothing else.
}
catch {
  Add-Content -path $ENV:ErrorLog -Value "$($currentUTCtime): Could not create new O365 JIT Account. Error:  $($_.Exception.Message)" -Force
  New-output -ReturnedBody "Group Add Failure: $($_.Exception.Message)"
  break
}

