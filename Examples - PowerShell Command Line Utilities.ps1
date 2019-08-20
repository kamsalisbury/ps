# PowerShell Command Line Utility Examples

# Execute a non-PowerShell CLI command from PowerShell
Start-Job -ScriptBlock {robocopy /E /IPG:3 "\\SourceHostOrFQDN\Share\SourcePath" "\\TargetHostOrFQDN\Share\TargetPath"}

# Use icacls to reset specific folder permissions, specifying inheritance on. Works local and Enter-PSsession
icacls "Path-to-folder" /grant "DOMAIN\Login:(OI)(CI)M" /T /Q

# Use icacls to reset permissions on folder previously permissioned incorrectly
icacls "Path-to-folder" /Q /C /T /reset 

# Who is logged on right now
query user /server:localhost

# https://blogs.msdn.microsoft.com/virtual_pc_guy/2013/02/25/backing-up-hyper-v-virtual-machines-from-the-command-line/
wbadmin start backup -backupTarget:\\FQDN\Path -hyperv:VM1,VM2,"Ubuntu LTS" -include:c:,d:,e: -allCritical -systemstate -vssFull

# Windows backup, delete all but the last two backups
wbadmin delete backup -keepVersions:2

# Configure workstation to remote manage Hyper-V Server core
# https://blogs.msdn.microsoft.com/virtual_pc_guy/2010/11/11/configuring-remote-management-of-hyper-v-server-in-a-workgroup/
winrm quickconfig
winrm set winrm/config/client @{TrustedHosts="RemoteComputerName"}
netsh advfirewall firewall set rule group="Remote Volume Management" new enable=yes
# Configure Hyper-V Server core to be remote managed
# https://blogs.msdn.microsoft.com/virtual_pc_guy/2010/11/11/configuring-remote-management-of-hyper-v-server-in-a-workgroup/
reg add HKLM\Software\Policies\Microsoft\Windows\DeviceInstall\Settings /v AllowRemoteRPC /t reg_dword /d 1
# http://joe.blog.freemansoft.com/2013/02/enabling-remote-management-for-windows.html
netsh advfirewall firewall set rule group="Windows Management Instrumentation (WMI)" new enable=yes
netsh advfirewall firewall set rule group="remote event log management" new enable=yes
# http://retrohack.com/howtoset-a-windows-server-2016-hyper-v-host-to-use-sntp-for-time-sync/
w32tm /config /syncfromflags:MANUAL /manualpeerlist:us.pool.ntp.org /reliable:yes /update
net stop w32time && net start w32time
