# Create a new scheduled task, writing application log entries to a file

$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-NoProfile -WindowStyle Hidden -command "& {get-eventlog -logname Application -After ((get-date).AddDays(-1)) | Export-Csv -Path Path\applog.csv -Force -NoTypeInformation}"'

$trigger =  New-ScheduledTaskTrigger -Daily -At 1am

Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "AppLog" -Description "Daily dump of Applog"