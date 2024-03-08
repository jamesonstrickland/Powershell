# Replace 'USABQ00043136' with the actual hostname or IP address of the remote PC
$remoteComputer = 'USABQ00043136'

# Specify the credentials for remote connection
$credential = Get-Credential

# Define the script block to get the list of running processes
$scriptBlock = {
    Get-Process
}

# Invoke the command on the remote computer
$result = Invoke-Command -ComputerName $remoteComputer -Credential $credential -ScriptBlock $scriptBlock

# Display the results
$result

