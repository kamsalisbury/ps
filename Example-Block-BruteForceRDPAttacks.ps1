# Block-BruteForceRDPAttacks.ps1
# A simple example PowerShell script to block RDP attacks.
# Requires: No dependencies
# Recommended: After testing, schedule PowerShell with parameters -NoProfile -File Full-path-to-script

# --- Define settings in this section

# This name of the blocking firewall rule (set for TCP Port 3389) must be created manually first
$fwrule = "Block RDP Attacks"

# Increase -Hour 1 to find more than last 1 hours, can also use more than -Day 1
$twindow = (Get-Date) - (New-TimeSpan -Hour 1)

# Define how many failed attempts means an attacker
$attacks = 5

# --- End settings section

# Find just failed RDP NLA attempts
$id140 = Get-WinEvent -ErrorAction SilentlyContinue -FilterHashTable @{LogName = "Microsoft-Windows-RemoteDesktopServices-RdpCoreTS/Operational"; starttime=$twindow ; id=140} | Select -Property Message

# Create list of just IPs from $attempts failed attempts
#$iplist = ($id140 | Select-String -Pattern "\d{1,3}(\.\d{1,3}){3}" -AllMatches).Matches.Value | Get-Unique
$iplist = ($id140 | Select-String -Pattern "\d{1,3}(\.\d{1,3}){3}" -AllMatches).Matches.Value | Group-Object | Where-Object {$_.Count -ge $attacks} | Select-Object -ExpandProperty Name -Unique
$iplist = @($iplist)

# List the existing blocked RemoteAddress
$blocklist = (Get-NetFirewallRule -DisplayName $fwrule | Get-NetFirewallAddressFilter).RemoteAddress

# Add new IPs to current list
$newlist = $iplist + $blocklist | Select-Object -Unique

# Update the firewall rule
Set-NetFirewallRule -DisplayName $fwrule -RemoteAddress $newlist

# Show new list of blocked IPs
# (Get-NetFirewallRule -DisplayName $fwrule | Get-NetFirewallAddressFilter).RemoteAddress > Path-to-Where-You-Want-A-Log-Saved\PS-Block-BruteForceRDPAttacks.log