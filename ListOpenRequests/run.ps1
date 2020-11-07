using namespace System.Net
param($Request, $TriggerMetadata)
function New-output ($ReturnedBody) {
  Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
      StatusCode  = [HttpStatusCode]::OK
      Body        = $ReturnedBody
      ContentType = 'text/json'
    }) 
}


try {
#Get all request in database with state New,Active,Denied,Reviewed. Return requests HTML as a table. nothing else.
}
catch {
  Add-Content -path $ENV:ErrorLog -Value "$($currentUTCtime): Could not create new O365 JIT Account. Error:  $($_.Exception.Message)" -Force
  New-output -ReturnedBody "Group Add Failure: $($_.Exception.Message)"
  break
}

