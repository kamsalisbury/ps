# Example-Secure-EMail-StoreCredentials.ps1
# A simple example PowerShell script to store email account credentials in a secure manner
# Requires: No dependencies
# Recommended: The output storage location should also be protected from public access 

# Store internet email credentials. PowerShell hashes the credential against the login account SID and the machine's SID, so the file is useless on any other machine, or in anyone else's hands.
$cred = Get-Credential
$cred | Export-CliXml your-email-cred.clixml
$EmailCredential = Import-CliXml your-email-cred.clixml