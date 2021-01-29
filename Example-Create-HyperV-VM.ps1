# Example-Create-HyperV-VM.ps1
# A simple example PowerShell script to create a VM on a HyperV host
# Requires: Install-WindowsFeature -Name Hyper-V -ComputerName <computer_name> -IncludeManagementTools -Restart

# Variables
$VM = Read-Host -Prompt 'The VM name? ex. mrbrown'
$VMdisksize = Read-Host -Prompt 'The VM disk size in GB? ex. 30GB'
$ISOinstall = Read-Host -Prompt 'The ISO for install? ex. D:\ISOs\rhel-8.1-x86_64-dvd.iso'
$CPUs = Read-Host -Prompt 'The number of CPUs the VM can use? ex. 2'
$Switch = Read-Host -Prompt 'The virtual switch to connect? ex. External1'
$Notes = Read-Host -Prompt 'Brief note about this VM? ex. Main Proxy'
$VMpath = 'D:\VMs' # Can be converted to a prompt like the variables shown above, but usually hard coded for each VM Host
$VMdisk = $VMpath + "\" + $VM + ".vhdx"

# Create the VM
New-VM -Name $VM -MemoryStartupBytes 4096MB -Path $VMpath -SwitchName $Switch -Generation 2
# Create the VM disk
New-VHD -Path $VMdisk -SizeBytes $VMdisksize -Dynamic
# Connect VM disk to the VM
Add-VMHardDiskDrive -VMName $VM -Path $VMdisk
# Specify the install ISO location and connect to VM
Set-VMDvdDrive -VMName $VM -ControllerNumber 1 -Path $ISOinstall
# Specify dynamic ram
Set-VMMemory -VMName $VM -DynamicMemoryEnabled $true -StartupBytes 4096MB -MinimumBytes 512MB -MaximumBytes 4096MB
# Configure processor use
Set-VMProcessor -VMName $VM -Count $CPUs -EnableHostResourceProtection $true # Exposing CPU threads per a CPU core is supported in HV2019, -HwThreadCountPerCore 0
# Configure secure boot for Gen 2 type VM
Set-VMFirmware -VMName $VM -EnableSecureBoot On 
# Disable automatic checkpoints, or enable them by setting $true
Set-VM -VMName $VM -AutomaticCheckpointsEnabled $false -CheckpointType Standard -Notes $Notes
# Enable guest integration services
Enable-VMIntegrationService -VMName $VM -Name 'Guest Service Interface'
