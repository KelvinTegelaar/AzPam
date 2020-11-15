using namespace System.Net
param($Request, $TriggerMetadata)
. .\GenericFunctions.ps1

$Table = $Request.Query.Table
$AzPAMID = $Request.Query.FilterID
#Add filter option
try {
  if ($AzPAMID) {
    $Requests = Get-AzPAMTable -Table $Table | Sort-Object -Property TableTimeStamp -Descending | Select-object * -ExcludeProperty PartitionKey, RowKey, TableTimeStamp, Etag | Where-Object { $_.AzPAMID -eq $AzPAMID }
  }
  else {
    $Requests = Get-AzPAMTable -Table $Table | Sort-Object -Property TableTimeStamp -Descending | Select-object * -ExcludeProperty PartitionKey, RowKey, TableTimeStamp, Etag
  }
  new-output (convertto-json ([array]$Requests))
}
catch {
  Write-AzPAMLogTable -type "Error" -Message "Could not get Azure Table $($_.Exception.Message)" -SourceAccount "SYSTEM" -AzPAMID $AzPAMID
  New-output -ReturnedBody "Failed: $($_.Exception.Message)"
  break
}

