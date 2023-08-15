# Example-Backfill-DNS-PTR.ps1
# A simple example PowerShell script to create DNS PTR (reverse lookup) records for existing DNS A records.
# Requires: No dependencies

# Creates PTR Records for all A Records in the specified -ZoneName.

$ComputerName = 'AD.DC.FQDN'
$Domain = '.sub.domain.tld'
$Zone = 'sub.domain.tld'

$records = (Get-DnsServerResourceRecord -ZoneName $Zone -RRType A -ComputerName $ComputerName | Where-Object -FilterScript {$_.HostName -like '*.not-zone-sub'})

ForEach ($record in $records){
              $ipv4 = Get-DnsServerResourceRecord -ZoneName $Zone -RRType A -ComputerName $ComputerName -Name $record.HostName | Select-Object -ExpandProperty RecordData
              $Name = ($ipv4.IPv4Address.ToString() -replace '^(\d+)\.(\d+)\.(\d+).(\d+)$','$4')
              $ZoneName = ($ipv4.IPv4Address.ToString() -replace '(\d+)\.(\d+)\.(\d+)\.(\d+)', '$3.$2.$1') + ".in-addr.arpa"
              $PtrDomainName = $record.HostName + $Domain
              Add-DnsServerResourceRecordPtr -Name $Name -ZoneName $ZoneName -PtrDomainName $PtrDomainName -ComputerName $ComputerName
}