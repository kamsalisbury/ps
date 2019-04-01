# PowerShell Command Line Utility Examples

# Execute a non-PowerShell CLI command from PowerShell
Start-Job -ScriptBlock {robocopy /E /IPG:3 "\\HostOrFQDN\Share\SourcePath" "\\HostOrFQDN\Share\TargetPath"}

# Use icacls to reset specific folder permissions, specifying inheritance on. Works local and Enter-PSsession
icacls "Path-to-folder" /grant "DOMAIN\Login:(OI)(CI)M" /T /Q

# Use icacls to reset permissions on folder previously permissioned incorrectly
icacls "Path-to-folder" /Q /C /T /reset 

# Who is logged on right now
query user /server:localhost
