using namespace System.Net
param($Request, $TriggerMetadata)
. .\GenericFunctions.ps1
$Page = $Request.Query.Page

if (!$Page) { $Page = 'index.html' }


try {
  $Page = get-content "interface/$($Page)" | Out-String
  Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode  = [HttpStatusCode]::OK
    Body        = $Page
    ContentType = 'text/html'
}) 
}
catch {
  Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode  = [HttpStatusCode]::OK
    Body        = '404 - page not found.'
    ContentType = 'text/html'
}) 
}

