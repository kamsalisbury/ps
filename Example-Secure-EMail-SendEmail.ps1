# Example-Secure-EMail-SendEmail.ps1
# A simple example PowerShell script to send email.
# Requires: No dependencies

$EmailCredential = Import-CliXml your-email-cred.clixml
$EmailSubject = "Test 3535"
$EmailBody = "Testing sending email"
Send-MailMessage -SmtpServer smtpout.server.tld -Port 3535 -Credential $EmailCredential -From 'you@domain.tld' -To 'someone@otherdomain.tld' -Subject $EmailSubject -Body $EmailBody