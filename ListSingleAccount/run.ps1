using namespace System.Net
param($Request, $TriggerMetadata)
function New-output ($ReturnedBody) {
  Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
      StatusCode  = [HttpStatusCode]::OK
      Body        = $ReturnedBody
      ContentType = 'text/json'
    }) 
}
$AccountID = $Request.Body.AccountID

try {
#Get specific account, return info
}
catch {
  Add-Content -path $ENV:ErrorLog -Value "$($currentUTCtime): Could not create new O365 JIT Account. Error:  $($_.Exception.Message)" -Force
  New-output -ReturnedBody "Group Add Failure: $($_.Exception.Message)"
  break
}

