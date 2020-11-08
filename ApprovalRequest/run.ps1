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

  Write-AzPAMTable -Table "Requests" -Data $AccountReq
  Write-AzPAMLogTable -type "Info" -Message "Requested new account for $($Account['Tenant'])" -SourceAccount "$($Account['RequestedBy'])"
}
catch {
  Write-AzPAMLogTable -type "Error" -Message "Could not create account request. Error:  $($_.Exception.Message)" -SourceAccount "SYSTEM"
  New-output -ReturnedBody "Request Failure: $($_.Exception.Message)"
  break
}

New-output -ReturnedBody "Succesfully created request"