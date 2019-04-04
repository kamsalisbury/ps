# Log-Network-Latency.ps1
# A simple example PowerShell script to log average PING utility packet latency to CSV file for use in other analysis.
# Requires: No dependencies
# Recommended: After testing, schedule PowerShell with parameters -NoProfile -File Full-path-to-script

<# Use the following commands to create the per-machine encrypted credential storage for use in the script
$cred = Get-Credential
$cred | Export-CliXml your-email-cred.clixml
#>

$EmailCredential = Import-CliXml kamsalisbury-sendgrid-email-cred.clixml
$SMTPServer = “relay.domain.tld”
$SMTPPort = “587”
$Username = ($EmailCredential).username
$Password = ($EmailCredential).password
$to = “receiver@domain.tld”

# Read current Hyper-V Replication Health
$test = Get-VMReplication | Select-Object Name,Health

# Evaluate *add -NOT back
$test | ForEach {if (-NOT $_.Health -eq "Normal" ){$results += @($_.Name + " " + $_.Health + " " + "issue" + "`r`n")} Else {Exit}}
 
    $subject = “Replica issue on $env:comptuername”
    $message = New-Object System.Net.Mail.MailMessage
    $message.Body = $results
    $message.subject = $subject
    $message.from = $Username
    $message.to.add($to)
    $smtp = New-Object System.Net.Mail.SmtpClient($SMTPServer, $SMTPPort);
    $smtp.EnableSSL = $true
    $smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
    $smtp.send($message)
