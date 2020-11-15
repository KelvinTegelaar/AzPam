using namespace System.Net
param($Request, $TriggerMetadata)
. .\Genericfunctions.ps1
# Input bindings are passed in via param block.

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."
if ($null -eq $Request.headers.'X-MS-CLIENT-PRINCIPAL-NAME') { $User = "Unknown" } else { $User = $Request.headers.'X-MS-CLIENT-PRINCIPAL-NAME' }
$account = $Request.body | ConvertFrom-Json 
try {
  $AccountReq = @{
    RequestName         = $Account.RequestName
    RequestedBy         = $User
    RequestType         = $Account.RequestType
    RequestTenant       = $Account.RequestTenant
    RequestedOn         = (Get-Date).ToUniversalTime()
    RequestedUsername   = $Account.RequestedUsername
    RequestedRole       = $Account.RequestedRole
    RequestedExpireDate = $Account.RequestedExpireDate
    RequestedReason     = $Account.RequestedReason
    RequestStatus       = 'New'
    AzPAMID             = (New-Guid).guid
  }
  Write-AzPAMTable -Table "Requests" -Data $AccountReq
  Write-AzPAMLogTable -type "Info" -Message "Requested new account for $($AccountReq.RequestTenant)" -SourceAccount "$($accountreq.RequestedBy)"
}
catch {
  Write-AzPAMLogTable -type "Error" -Message "Could not create account request. Error:  $($_.Exception.Message)" -SourceAccount "SYSTEM"
  New-output -ReturnedBody "Request Failure: $($_.Exception.Message)"
  break
}

New-output -ReturnedBody 'Succesfully created new request.'