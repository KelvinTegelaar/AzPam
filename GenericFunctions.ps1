function New-output ($ReturnedBody) {
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode  = [HttpStatusCode]::OK
        Body        = $ReturnedBody
        ContentType = 'text/json'
      }) 
  }