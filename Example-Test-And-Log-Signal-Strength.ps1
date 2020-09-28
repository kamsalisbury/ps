# Test and Log Wireless Signal Strength by Kam Salisbury
# More scripts available in my book PowerShell for IT Helpdesk and Admins https://amzn.to/2YyQsD7

# Clear console https://ss64.com/ps/clear-host.html
Clear-Host

# Display text to console, https://ss64.com/ps/write-host.html
Write-Host "This script will execute a wireless signal survey a number of times with a number of seconds between tests. Progress will display upon the screen. Upon survey completion, results will display to the console and log to file."

# Request how many seconds to test, https://ss64.com/ps/read-host.html
$test = Read-Host -Prompt "How many times to test signal?"
$interval = Read-Host -Prompt "How many seconds between each test?"

# Create a counter for progress display
$tests = $test

# Create empty array to hold results,https://ss64.com/ps/syntax-arrays.html
$signal = @()

# Create date time stamp variable for log file, https://ss64.com/ps/get-date.html
$datetimestamp = (Get-Date).ToString("yyyyMMdd-HHmm")

# Loop, https://ss64.com/ps/for.html
for($i = 0; $i -lt $test; $i++) {

    # Extract the signal strength value from the utility output using regex, https://ss64.com/ps/syntax-regex.html
    $signal += ((netsh wlan show interfaces) -Match '^\s+Signal' -Replace '^\s+Signal\s+:\s+','' -Replace '%')
    
    # Delay script execution before next loop, https://ss64.com/ps/start-sleep.html
    Start-Sleep -seconds $interval
    
    # Display progress
    Clear-Host
    $tests = ($tests - 1)
    Write-Host "$tests tests left..."
    
    }

# Display stats, https://ss64.com/ps/measure-object.html
$signal | Measure-Object -Average -Maximum -Minimum -StandardDeviation

# Output stats to logfile,https://ss64.com/ps/out-file.html
$signal | out-file -FilePath ($datetimestamp + "_SignalStrengthSurvey.log")