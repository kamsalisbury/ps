# PowerShell Tips Tricks Examples

# Combine statements on one line using semicolon. A work-a-round for pipeline limitations.
$test=(Get-ChildItem C:\Users -Recurse |Measure-Object -Property Length -Sum); $test.sum /1GB

# List printer shares to text file
Get-WmiObject Win32_Printer -ComputerName "FQDN" | Select-Object ShareName, PortName >> PrinterShares.txt

# List logged on accounts, similar to the linux who or w commands
Get-WmiObject Win32_LoggedOnUser -ComputerName "FQDN" | Select-Object Antecedent -Unique

# When configuring Windows to run PowerShell scripts, specify the "powershell" executable
# then -NoProfile -File Path\script.ps1
# then folder "Path"

# Diagnostic connection information
Test-NetConnection -ComputerName FQDN -InformationLevel Detailed

# Simple connectivity status
Test-NetConnection -ComputerName FQDN -Port 80 -InformationLevel Quiet
