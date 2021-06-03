# AbuseIPDB-IP-Check.ps1
# A simple example PowerShell script to query the AbuseIPDB API about an IP address

# Prompt for the IP to check
$checkIP = Read-Host "Which IP to check against the AbuseIPDB API?"
# Prompt for date range, min 1, max 365. See reference https://docs.abuseipdb.com/#check-endpoint
$checkRange = Read-Host "How many days back to query?"
# Your AbuseIPDB application key
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$abuseipdbKey = ''
$headers.Add("Key", "$abuseipdbKey")
# POST the query
$check = (Invoke-RestMethod -Uri 'https://api.abuseipdb.com/api/v2/check' -Method Get -ContentType application/json -Headers $headers -Body @{ipAddress="$checkIP";maxAgeInDays=$checkRange;})
# Display results
$check.data | Select-Object -Property ipAddress,abuseConfidenceScore,countryCode,isp,domain,totalReports,numDistinctUsers,lastReportedAt | FL