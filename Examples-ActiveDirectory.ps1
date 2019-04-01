# PowerShell Active Directory Examples

# List Active Directory Groups matching a search
Get-ADGroup -Filter "Name -like '*GroupName*'" | Select-Object Name

# List members of an Active Directory Group
Get-ADGroup GroupName | Get-ADGroupMember | Select-Object Name

# List all members of a nested Active Directory Group, output to CSV
Get-ADGroupMember -Identity "GroupName" -Recursive | Get-ADUser -Properties * | Select-Object City, Name, SamAccountName, UserPrincipalName, OfficePhone, EmailAddress | Export-Csv NestedGroupMembers.csv -NoTypeInformation -Append

# List AD Accounts and Password Expirations
Get-ADUser -Filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} -SearchBase "OU=OUname,DC=DCname1,DC=TLD" -Properties DisplayName,Name,LastLogonDate,msDS-UserPasswordExpiryTimeComputed | Select-Object -Property "Displayname",LastLogonDate,@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}

# List already locked out logins
$PDC = (Get-ADDomain).PDCEmulator; Get-EventLog -LogName Security -ComputerName $PDC | Where-Object {$_.EventID -eq 4740} | Format-List -Property TimeGenerated, ReplacementStrings, Message

