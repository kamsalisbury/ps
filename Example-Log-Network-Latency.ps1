# Example-Log-Network-Latency.ps1
# A simple example PowerShell script to log average PING utility packet latency to CSV file for use in PowerBI or other analysis.
# Requires: No dependencies
# Recommended: After testing, schedule PowerShell with parameters -NoProfile -File Full-path-to-script

# Supply the target to be monitored 
$target= 'host or fqdn'

# Setup test connection
$count= 8
$con = Test-Connection $target -count $count
$average = ($con.ResponseTime | Measure-Object -Average).Average
$lost = $count-($con.count)

# Build log entry
$RunDateTime = (Get-Date).ToString()
$log = $RunDateTime + "," + $average

# Log
$log | Out-File -FilePath Full-Path-To-Save-CSV-Log-File\Latency.csv -Append