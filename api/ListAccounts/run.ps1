using namespace System.Net
param($Request, $TriggerMetadata)
. .\GenericFunctions.ps1
$Filter = $Request.Body.Filter
if (!$Filter) { $Filter = '*' }
try {
  $AccountTable = Get-AzPAMTable -Table $Table | Where-Object { $_.Status -like $Filter }
  New-output -returnedbody $AccountTable
}
catch {
  Add-Content -path $ENV:ErrorLog -Value "$($currentUTCtime): Could not create new O365 JIT Account. Error:  $($_.Exception.Message)" -Force
  New-output -ReturnedBody "Could not retrieve Accounts"
  break
}

