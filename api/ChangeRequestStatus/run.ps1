using namespace System.Net
param($Request, $TriggerMetadata)
. .\Genericfunctions.ps1
# Input bindings are passed in via param block.

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."
if ($null -eq $Request.headers.'X-MS-CLIENT-PRINCIPAL-NAME') { $User = "Unknown" } else { $User = $Request.headers.'X-MS-CLIENT-PRINCIPAL-NAME' }
$account = $Request.body
try {
  $AzPamTableRow = Get-AzPAMTable -Table Requests | Where-Object { $_.AzPAMID -eq $Account.AzPAMID } | ForEach-Object { $_.RequestStatus = $Account.NewStatus; $_ }
  Update-AzPAMTable -Table Requests -NewData $AzPamTableRow
  Write-AzPAMLogTable -type "Info" -Message "Requested status changed for $($AzPamTableRow.RequestTenant)" -SourceAccount "$($user)" -AzPAMID $Account.AzPAMID
}
catch {
  Write-AzPAMLogTable -type "Error" -Message "Could not change account request. Error:  $($_.Exception.Message)" -SourceAccount "SYSTEM" $Account.AzPAMID
  New-output -ReturnedBody "Request Failure: $($_.Exception.Message)"
  break
}

New-output -ReturnedBody 'Succesfully created new request.'

