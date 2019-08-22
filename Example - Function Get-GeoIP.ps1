<#
.SYNOPSIS
Get-GeoIP.ps1 - Query ipstack.com for IP address geolocation data

.DESCRIPTION 
This PowerShell script performs a REST API query to ipstack.com to retrieve IP address geolocation information.

.OUTPUTS
Results are output to the console and variable.

.PARAMETER IP
Specifies the IP address to lookup.

.PARAMETER Key
Specifies the ipstack.com API access key used to perform the query.

.EXAMPLE
.\Get-GeoIP.ps1 -IP 1.1.1.1

.NOTES
By: Kam Salisbury

Find me at http://kam.salisburyfamily.us/

ipstack.com is a publicly accessible HTTP API for geolocation information and offers free accounts up to 10,000 queries per month by default.

Change Log...
Version1.00, 2019-08-20 - Initial version
#>

param (

    [Parameter(Mandatory=$true, Position=0, HelpMessage="`t Enter the IP Address to query")]
    [string] $IP
    ,
	[Parameter(Mandatory=$true, Position=1, HelpMessage="`t Enter your API access key from ipstack.com")]
	[string] $Key
)

function Get-GeoIP() {
        $query = 'http://api.ipstack.com/'+$IP+'?access_key='+$Key
        $geoip = Invoke-RestMethod $query -ErrorAction Stop
    
        return $geoip
}

Get-GeoIP $ipaddress $ipstackkey