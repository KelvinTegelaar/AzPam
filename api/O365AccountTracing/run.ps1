# Input bindings are passed in via param block.
param($Timer)
$currentUTCtime = (get-date).ToUniversalTime()
# Write an information log with the current time.
Write-Host "PowerShell timer trigger function ran! TIME: $currentUTCtime"

try {
#Get all requests with status "Active". 
#for each of these accounts, do this: 	GET https://graph.microsoft.com/v1.0/auditLogs/directoryAudits. Will update every 15 minutes?
#If local account, when the tenant connect, it uploads all information for accounts that are managed by AzPAM via a customattribute.
}
catch {
    Add-Content -path $ENV:ErrorLog -Value "$($currentUTCtime): Could not blabla Error:  $($_.Exception.Message)" -Force
}