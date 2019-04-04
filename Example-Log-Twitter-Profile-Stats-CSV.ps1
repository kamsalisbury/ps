# Example-Log-Twitter-Profile-Stats-CSV.ps1
# This is a simple examplemPowerShell script that leverages the InvokeTwitterAPIs module from https://github.com/MeshkDevs/InvokeTwitterAPIs
# Requires: Please reviiew the module documentation as it has configuration dependencies. Twitter requires app API Keys.
# Recommended: After testing, schedule PowerShell with parameters -NoProfile -File Full-path-to-script
# I also recommend utilizing dot sourced credentials to store your Twitter API keys. At a minimum, modify the credentials file to restrict access to the account executing this script.

# Initialize variables
$screenname = 'TwitterScreenNameConfiguredWithAPIKeysAccess' # https://apps.twitter.com
$logfile = 'C:\Users\account-running-scripts\path\Logs\Twitter-Profile-Stats.csv'
$cred = "C:\Users\account-running-scripts\path\Twitter-OAuth.ps1"

# Get Twitter Access
Import-Module -Name InvokeTwitterAPIs

# Dot source API Keys
. $cred

# Collect twitter profile stats
$twid = (Get-TwitterUser_Lookup -screen_name $screenname | Select-Object followers_count,friends_count,listed_count)

# What day and time is it?
$RunDateTime = (Get-Date).ToString()

# Log it
$log = $RunDateTime + "," + $twid.followers_count + "," + $twid.friends_count + "," + $twid.listed_count
$log | Out-FIle -FilePath $logfile -Append