# Inventory bitlocker status for one+ computers listed in a plain text file

# Request targets path and filename
$TextFileAndPath = Read-Host "What is the full path and name of the target computer names text file?"
# Check the provided path and filename
if (Test-Path $TextFileAndPath) {
    # Read the targets into a variable
    $Targets = Get-Content $TextFileAndPath
    # Specify an empty array
    $TargetStatus = @()
    ForEach-Object ($Computer in $Targets) {
        $ComputerStatus = manage-bde -status -cn "$Computer"
        $TargetStatus += $ComputerStatus
    }
    $TargetStatus | Out-File -FilePath "Path\filename.txt" -Append -Force
} else {
    Write-Error "The specified path and-or text file NOT FOUND, please try again."
}