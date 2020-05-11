# PS-Report-Abuse.ps1
# A simple example PowerShell script to isolate and report attacking IPs.
# Requires: Uses some unix OS utilities and logwatch
# Recommended: After testing, schedule PowerShell with crontab Full-path-to-pwsh Full-path-to-script
cd /home/user

# Logwatch output source data
/bin/bash -c "/sbin/logwatch --detail low --range 'since 6 hours ago for those hours' --service iptables > /home/user/output.txt"

# Pre-process source data
/bin/bash -c "grep '\(25[0-5]\|2[0-4][0-9]\|[01][0-9][0-9]\|[0-9][0-9]\)\.\(25[0-5]\|2[0-4][0-9]\|[01][0-9][0-9]\|[0-9][0-9]\)\.\(25[0-5]\|2[0-4][0-9]\|[01][0-9][0-9]\|[0-9][0-9]\)\.\(25[0-5]\|2[0-4][0-9]\|[01][0-9][0-9]\|[0-9][0-9]\)' /home/user/output.txt > /home/user/abuse.txt"

# Variables
$ReportDate = (Get-Date -Format o)
# Document monitoring IPs
$whitelistips = (Get-Content whitelist.txt)

# CSV Format is IP,Categories,ReportDate,Comment
$Comment = " "

# Create list of blocked IPs from linux syslog
# Trim leading spaces
(Get-Content ./abuse.txt).replace('   ','') | Set-Content ./abuse.txt

# Convert list of blocked abuse.txt IPs into array $data
$data = Import-Csv -Path abuse.txt -Header "FromTXT","FromIP","NA1","PacketCount","NA2","NA3","Ports" -Delimiter " "

# Check $data object against whitelist.txt
$abuse = ($data | where {$data -NotContains $whitelistips})

# Evaluate array into abuse categories
# Abuseipdb.com category 6 POD
$abuse6 = ($abuse | Where {$_.Ports -Match 'icmp'})
$Categories = "6"
$output = @()
$abuse6 | ForEach-Object {
    $output += [pscustomobject]@{
        IP = $_.FromIP
        Categories = $Categories
        ReportDate = $ReportDate
        Comment = $Comment + " " + $_.PacketCount + " packets to " + $_.Ports
    }
}
$output | Export-Csv -Path "abuse6.csv" -NoTypeInformation

# Evaluate array into abuse categories
# Abuseipdb.com category 14 Portscan
$abuse14 = ($abuse | Where {$_.PacketCount -gt '2'})
$Categories = "14"
$output = @()
$abuse14 | ForEach-Object {
    $output += [pscustomobject]@{
        IP = $_.FromIP
        Categories = $Categories
        ReportDate = $ReportDate
        Comment = $Comment + " " + $_.PacketCount + " packets to " + $_.Ports
    }
}
$output | Export-Csv -Path "abuse14.csv" -NoTypeInformation

# Abuseipdb.com category 18 Brute Force
$abuse18 = ($abuse | Where {$_.Ports -Match '\(21\)|\(21,|,21,|,21\)|\(22\)|\(22,|,22,|,22\)|\(23\)|\(23,|,23,|,23\)|\(3389\)|\(3389,|,3389,|,3389\)'})
$Categories = "18"
$output = @()
$abuse18 | ForEach-Object {
    $output += [pscustomobject]@{
        IP = $_.FromIP
        Categories = $Categories
        ReportDate = $ReportDate
        Comment = $Comment + " " + $_.PacketCount + " packets to " + $_.Ports
    }
}
$output | Export-Csv -Path "abuse18.csv" -NoTypeInformation

# Abuseipdb.com category 20 Compromised Host
# Known infected-compromised hosts looking to infect others ex. https://www.speedguide.net/port.php?port=55555
$abuse20 = ($abuse | Where {$_.Ports -Match '\(2323\)|\(2323,|,2323,|,2323\)|\(3127\)|\(3127,|,3127,|,3127\)|\(3410\)|\(3410,|,3410,|,3410\)|\(7547\)|\(7547,|,7547,|,7547\)|\(8291\)|\(8291,|,8291,|,8291\)|\(55555\)|\(55555,|,55555,|,55555\)'})
$Categories = "20"
$output = @()
$abuse20 | ForEach-Object {
    $output += [pscustomobject]@{
        IP = $_.FromIP
        Categories = $Categories
        ReportDate = $ReportDate
        Comment = $Comment + " " + $_.PacketCount + " packets to " + $_.Ports
    }
}
$output | Export-Csv -Path "abuse20.csv" -NoTypeInformation

# Combine CSV outputs, filter for unique lines only
/bin/bash -c "rm -f /home/user/abuse-report.csv"
cat /home/user/abuse*.csv | /bin/sort -r | /bin/uniq > /home/user/abuse-report.csv"

# POST the submission.
$test = @(Get-Content /home/user/abuse-report.csv)
if ($test) {/bin/bash -c "curl https://api.abuseipdb.com/api/v2/bulk-report -F csv=@abuse-report.csv -H 'Key: your key from abuseipdb' -H 'Accept: application/json' > abuseipdb-reported.json"}
