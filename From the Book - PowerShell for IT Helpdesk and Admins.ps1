# Event Logs
# List target computer System Log Errors and Warnings
Get-EventLog -ComputerName $env:COMPUTERNAME -LogName System -Newest 100 -Before "01/01/2019" | Where {$_.EventType -like 'Error' -or $_.EventType -like 'Warning'} | Select-Object -Property Message

# List target computer System Log Disk Errors and Warnings
Get-EventLog -ComputerName $env:COMPUTERNAME -LogName System -Newest 100 | Where {$_.EventType -like 'Error' -or $_.EventType -like 'Warning'} | Where {$_.Source -like 'Disk'} | Select-Object -Property Time, Message

# List target computer specific Security Log eventID (for failed login)
Get-EventLog -ComputerName $env:COMPUTERNAME -LogName Security -Newest 100 | Where {$_.EventID -eq '4625'} | Select-Object -Property Time, Message

# List target computer Application Log for ten most recent items from a specific application or service
Get-EventLog -ComputerName $env:COMPUTERNAME -LogName Application -Newest 10 -Source "Windows Search Service"

# List Locked Out user accounts from PDC Emulator
Get-EventLog -LogName Security -ComputerName HostOrFQDN | Where-Object {$_.EventID -eq "4740"} | Format-List -Property TimeGenerated, ReplacementStrings, Message

# List service set to Auto but not Running
Get-WmiObject -ComputerName $env:COMPUTERNAME Win32_Service | Where-Object {$_.StartMode -eq 'Auto' -and $_.State -ne 'Running'} | Format-Table -AutoSize

# Combine statements on one line using semicolon. A work-a-round for pipeline limitations and remote session access to script repositories.
$test=(Get-ChildItem C:\Users -Recurse |Measure-Object -Property Length -Sum); $test.sum /1GB

# Execute a non-PowerShell CLI command from PowerShell
Start-Job -ScriptBlock {robocopy /E /IPG:3 "\\HostOrFQDN\Share\SourcePath" "\\HostOrFQDN\Share\TargetPath"}

# Active Directory
# List Active Directory Groups matching a search
Get-ADGroup -Filter "Name -like '*GroupName*'" | Select-Object Name

# List members of an Active Directory Group
Get-ADGroup GroupName | Get-ADGroupMember | Select-Object Name

# List AD Accounts and Password Expirations
Get-ADUser -Filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} -SearchBase "OU=OUname,DC=DCname1,DC=TLD" -Properties DisplayName,Name,LastLogonDate,msDS-UserPasswordExpiryTimeComputed | Select-Object -Property "Displayname",LastLogonDate,@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}

# Display AD Group Members
Get-ADGroupMember <ADGroup> | Select-Object -Property Name

# List who is logged on to a specific computer
Get-Eventlog -LogName Security -ComputerName HostOrFQDN | Where-Object {$_.EventId -eq "4624"} | Select-Object @{Name="User"; Expression={$_.ReplacementStrings[5]}} | Sort-Object User -Unique

# Display folder permissions
Invoke-Command -Computer COMPUTERNAME -ScriptBlock {Get-Acl 'X:\FullPath\From\Target\Perspective' | Select -Expand Access | Select IdentityReference,FileSystemRights}

# Display CPU Processes using more than 100 seconds
Get-Process | Where-Object {$_.CPU -gt 100}
