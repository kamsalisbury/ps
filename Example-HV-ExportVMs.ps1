# https://social.technet.microsoft.com/Forums/ie/en-US/05fe9aab-9858-4ac5-b541-8eb7220b461d/powershell-script-to-export-virtual-machines
$Destination = "j:\Archive"
$VMs = Get-VM 
foreach ($VM in $VMs) { 
    if (Test-Path -Path $Destination\$($VM.Name)) { 
        Remove-Item -Path $Destination\$($VM.Name) -Force -Recurse -Confirm:$false
    } 
    Export-VM -Name $VM.Name -Path $Destination
}