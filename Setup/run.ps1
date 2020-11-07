using namespace System.Net
param($Request, $TriggerMetadata)
. .\GenericFunctions.ps1
#Create settings file with steps through.
try {
  foreach ($User in $users) {

    New-output -ReturnedBody "Success"

  }
}
catch {
  Add-Content -path $ENV:ErrorLog -Value "$($currentUTCtime): Could not create new O365 JIT Account. Error:  $($_.Exception.Message)" -Force
  New-output -ReturnedBody "Group Add Failure: $($_.Exception.Message)"
  break
}

