# Script to inventory specific file type

# First create target file which is also a log of targets inventoried
Get-ADComputer -Filter {(OperatingSystem -Like "Windows Server*") -and (Name -Like "*HOST*")} -SearchBase "OU=OUname,DC=DCname1,DC=DCname2,DC=TLD" -Property * | Select-Object Name | Export-Csv targets.csv -NoTypeInformation
# Assign variables
$Targets = Get-Content targets.csv
# Loop 
If (Test-Path $Targets){
    $TargetsArray = Get-Content $Targets
    ForEach-Object ($Target in $TargetsArray){
        Write-Host "Started processing $Target at $(Get-Date -DisplayHint DateTime)"
        Get-ChildItem -Path "\\$Target\Share\Path" *.ext -Recurse -File -ErrorAction SilentlyContinue | Select-Object CreationTime,LastWriteTime,Length,DirectoryName,Name,@{Name="Owner"; Expression={(Get-Acl $_.FullName).Owner}} | Export-Csv inventory-of-$Target-ext_$(Get-Date -f yyyy-MM-dd).csv -NoTypeInformation -Append
    }
}
Else {
    Write-Error "targets.csv NOT FOUND, check the path."
}
# Display completion time
Write-Host "Completed processing $(Get-Date -DisplayHint DateTime)"