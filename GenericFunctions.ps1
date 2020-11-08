function New-output ($ReturnedBody) {
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
            StatusCode  = [HttpStatusCode]::OK
            Body        = $ReturnedBody
            ContentType = 'text/json'
        }) 
}

function Write-AzPAMTable($Table, $Data) {
    $StorageAccountname = (($ENV:WEBSITE_CONTENTAZUREFILECONNECTIONSTRING) -split '=' -split ';')[3]
    $TableContext = (Get-AzStorageAccount | where-object { $_.StorageAccountName -eq $StorageAccountName }).Context
    $CloudTable = (Get-AzStorageTable -Name $Table -Context $TableContext).CloudTable
    $NewRowKey = [int64](Get-AzTableRow -table $CloudTable | Select-Object -Last 1).RowKey + 1
    $ReturnData = Add-AzTableRow -Table $CloudTable -property $Data -partitionKey 'partition1' -rowkey  $NewRowKey
    return $ReturnData
}

function Write-AzPAMLogTable ($Type, $Message) {
    $DateTime = (Get-Date).ToUniversalTime()
    $StorageAccountname = (($ENV:WEBSITE_CONTENTAZUREFILECONNECTIONSTRING) -split '=' -split ';')[3]
    $TableContext = (Get-AzStorageAccount | where-object { $_.StorageAccountName -eq $StorageAccountName }).Context
    $CloudTable = (Get-AzStorageTable -Name 'Logs' -Context $TableContext).CloudTable
    $NewRowKey = [int64](Get-AzTableRow -table $CloudTable | Select-Object -Last 1).RowKey + 1
    $ReturnData = Add-AzTableRow -Table $CloudTable -property @{ 'Type' = $Type; 'Message' = $Message; "DateTime" = $DateTime } -partitionKey 'partition2' -rowkey $NewRowKey
    return $ReturnData
}

function Get-AzPAMTable($Table) {
    $StorageAccountname = (($ENV:WEBSITE_CONTENTAZUREFILECONNECTIONSTRING) -split '=' -split ';')[3]
    $TableContext = (Get-AzStorageAccount | where-object { $_.StorageAccountName -eq $StorageAccountName }).Context
    $CloudTable = (Get-AzStorageTable -Name $Table -Context $TableContext).CloudTable
    $ReturnData = Get-AzTableRow -Table $CloudTable
    return $ReturnData
}
