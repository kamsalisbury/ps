# Example function for PowerShell Profile, automating manual Priviledged Administration Workstation elevation
function Elevate-OPS
{ param ([string]$role = 'ops');
	$session = New-PSSession -ComputerName server.domain.tld -ConfigurationName Elevate
	Invoke-Command -Session $session -ScriptBlock {Enable-Role $Using:rol}
	Remove-PSSession $session
}