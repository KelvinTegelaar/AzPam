using namespace System.Net
param($Request, $TriggerMetadata)
. .\Genericfunctions.ps1
# Input bindings are passed in via param block.

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."
$Account = [System.Web.HttpUtility]::ParseQueryString($Request.Body)
try {
  $AccountReq = [PSCustomObject]@{
    RequestName         = $Account['RequestName']
    RequestedBy         = $Account['RequestedBy']
    RequestType         = $Account['Type']
    RequestTenant       = $Account['RequestTenant']
    RequestedOn         = $Account['RequestDate']
    RequestedUsername   = $Account['RequestedUsername']
    RequestedRole       = $Account['RequestedRole']
    RequestedExpireDate = $account['RequestedExpireDate']
    RequestedReason     = $account['RequestedReason']
    RequestStatus       = 'New'
  }

  #Write request to Azure File Table / Cosmos
}
catch {
  Add-Content -path $ENV:ErrorLog -Value "$($currentUTCtime): Could not create new O365 JIT Account. Error:  $($_.Exception.Message)" -Force
  New-output -ReturnedBody "Request Failure: $($_.Exception.Message)"
  break
}

New-output -ReturnedBody "Succesfully created request"