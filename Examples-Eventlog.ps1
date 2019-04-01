# PowerShell Eventlog Examples

# System Log
# List System log Errors and Warnings
Get-EventLog -ComputerName $env:COMPUTERNAME -LogName System -Newest 100 -Before "01/01/2019" | Where {$_.EventType -like 'Error' -or $_.EventType -like 'Warning'} | Select-Object -Property Message

# List System log Disk Errors and Warnings
Get-EventLog -ComputerName $env:COMPUTERNAME -LogName System -Newest 100 | Where {$_.EventType -like 'Error' -or $_.EventType -like 'Warning'} | Where {$_.Source -like 'Disk'} | Select-Object -Property Time, Message

# Security Log
# List a specific Security log eventID (for failed login)
Get-EventLog -ComputerName $env:COMPUTERNAME -LogName Security -Newest 100 | Where {$_.EventID -eq '4625'} | Select-Object -Property Time,Message

# List who is logged on to a specific computer
Get-Eventlog -LogName Security -ComputerName HostOrFQDN | Where-Object {$_.EventId -eq "4624"} | Select-Object @{Name="User"; Expression={$_.ReplacementStrings[5]}} | Sort-Object User -Unique

# List Locked Out user accounts from PDC Emulator
Get-EventLog -LogName Security -ComputerName HostOrFQDN | Where-Object {$_.EventID -eq "4740"} | Format-List -Property TimeGenerated, ReplacementStrings, Message

# Application Log
# List Application log items for a specific application or service
Get-EventLog -LogName Application -Newest 10 -Source "Windows Search Service"
