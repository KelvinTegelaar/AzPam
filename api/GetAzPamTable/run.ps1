using namespace System.Net
param($Request, $TriggerMetadata)
. .\GenericFunctions.ps1

$Table = $Request.Body.Query.Table
#Add filter option
try {
 $Requests =  Get-AzPAMTable -Table $Table | Select-object * -ExcludeProperty PartitionKey,RowKey,TableTimeStamp,Etag |  convertto-html -Fragment | Out-String
  new-output $Requests
}
catch {
  Add-Content -path $ENV:ErrorLog -Value "$($currentUTCtime): Could not create new O365 JIT Account. Error:  $($_.Exception.Message)" -Force
  New-output -ReturnedBody "Group Add Failure: $($_.Exception.Message)"
  break
}

