# Create a Windows Backup Policy, add VMs, set a network share backup target, set schedule.

# Note: If using Windows Admin Center from Azure Portal, here is the work-a-round to saving credentials for input in the script. Warning! Do Not save this portion of the script anywhere. You will be saving your password in the clear. Use this portion of the script interactively.
#$username = "username with backup share access"
#$password = "long complex password"
#$secstr = New-Object -TypeName System.Security.SecureString
#$password.ToCharArray() | ForEach-Object {$secstr.AppendChar($_)}
#$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $secstr

# Create a variable to store the Windows Backup Policy, basically an object with defined variables for the backup task.
$policy = New-WBPolicy

# Add VMs to be backedup to the policy.
$vms = Get-WBVirtualMachine
Add-WBVirtualMachine -Policy $policy -VirtualMachine $vms

# Add the network share backup location.
$share = New-BackupTarget -NetworkPath "\\server\backup-share" -Credential $cred
Add-WBBackupTarget -Policy $policy -Target $share

# Use VSS copy to limit service interruption
Set-WBVssBackupOptions -Policy $policy -VssCopyBackup

# Optionally test the backup
# Start-WBBackup -Policy $policy

# Set the daily backup schedule using military 24 hour clock.
Set-WBSchedule -Policy $policy -Schedule 21:00

# Save the policy
Set-WBPolicy -Policy $policy

# Monitor backup job status
# Get-WBJob
# Get-WBSummary
# 
# $policy = Get-WBPolicy
# Get-WBSchedule -Policy $policy
# More info https://learn.microsoft.com/en-us/powershell/module/windowsserverbackup/?view=windowsserver2022-ps
