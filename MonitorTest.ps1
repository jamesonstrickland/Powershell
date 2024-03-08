# Replace 'RemoteComputer' with the actual hostname or IP address of the target PC
$remoteComputer = 'USABQM0TEST'
$credential = Get-Credential  # Enter credentials for the remote machine

# Define the list of directories to monitor on the remote machine
$directoriesToMonitor = @(
    "\\USABQM0TEST\BellMark\WEESUSMJ04R82U\artwork",
    "\\USABQM0TEST\BellMark\WEESUSMJ04R82W\artwork"
   
    # ... add paths for other directories
)

# Define the log file path on your local machine
$logFilePath = "C:\Users\3325764\Powershell\BellmarkMonitor\MonitoringLog.txt"

# Create a PSSession to the remote machine
$remoteSession = New-PSSession -ComputerName $remoteComputer -Credential $credential

# Enter the remote session
Enter-PSSession -Session $remoteSession

# Loop to continuously monitor directories on the remote machine
while ($true) {
    foreach ($directory in $directoriesToMonitor) {
        $currentDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

        # Get the list of files in the directory
        $currentFiles = Get-ChildItem -Path $directory | Select-Object FullName

        # Compare the current files with the previous run
        if ($null -ne $previousFiles) {
            $addedFiles = Compare-Object -ReferenceObject $previousFiles -DifferenceObject $currentFiles -Property FullName -PassThru |
                Where-Object { $_.SideIndicator -eq '<=' } |
                Select-Object -ExpandProperty FullName

            $removedFiles = Compare-Object -ReferenceObject $currentFiles -DifferenceObject $previousFiles -Property FullName -PassThru |
                Where-Object { $_.SideIndicator -eq '<=' } |
                Select-Object -ExpandProperty FullName

            # Log added files
            if ($addedFiles.Count -gt 0) {
                "$currentDate - Files added to $directory`n$($addedFiles -join "`n")" | Out-File -Append -FilePath $logFilePath
            }

            # Log removed files
            if ($removedFiles.Count -gt 0) {
                "$currentDate - Files removed from $directory`n$($removedFiles -join "`n")" | Out-File -Append -FilePath $logFilePath
            }
        }

        # Update the previous files for the next comparison
        $previousFiles = $currentFiles
    }

    # Wait for 5 seconds before the next iteration
    Start-Sleep -Seconds 5
}

# Exit the remote session
Exit-PSSession

# Remove the PSSession
Remove-PSSession -Session $remoteSession
