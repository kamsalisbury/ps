# Example-Submit-URLs-Bing-API.ps1
# A simple example PowerShell script to submit URLs to the Bing API. More information at https://www.bing.com/webmasters/url-submission-api#Documentation
# Requires: No dependencies

$BingAPIkey = Read-Host -Prompt 'Input your Bing API key...' # Or edit this script to dot source the key file
$Domain = Read-Host -Prompt 'Input the main domain url ex. https://domain.tld'
$URI = Read-Host -Prompt 'Input a URL to submit ex. https://domain.tld/page.html'
$BingAPIendpoint = 'https://ssl.bing.com/webmaster/api.svc/json/SubmitUrl?apikey=' + $BingAPIkey
# Headers not needed for this script but provided to be an easy template
#$headers = @{
# parameter = "value"
#}
$body = @{
    siteUrl = "$Domain"
    url = "$URI"
}

Invoke-RestMethod -Method Post -Uri "$BingAPIendpoint" -Body (ConvertTo-Json $body) -ContentType 'application/json'
