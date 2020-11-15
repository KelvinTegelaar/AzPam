using namespace System.Net
param($Request, $TriggerMetadata)
. .\GenericFunctions.ps1

$Table = $Request.Query.Table
$AccountID = $Request.Query.FilterID
#Add filter option
try {
  if ($AccountID) {
    $Requests = Get-AzPAMTable -Table $Table | Select-object * -ExcludeProperty PartitionKey, RowKey, TableTimeStamp, Etag | Where-Object { $_.UniqueID -eq $AccountID }
  }
  else {
    $Requests = Get-AzPAMTable -Table $Table | Select-object * -ExcludeProperty PartitionKey, RowKey, TableTimeStamp, Etag
  }
  new-output ([array]$Requests | convertto-json)
}
catch {
  Write-AzPAMLogTable -type "Error" -Message "Could not get Azure Table $($_.Exception.Message)" -SourceAccount "SYSTEM"
  New-output -ReturnedBody "Failed: $($_.Exception.Message)"
  break
}

