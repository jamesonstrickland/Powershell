# Define the remote computer name or IP address
$remoteComputer = "AZUSE2BELMRK01" 
# Specify the service name to be stopped
$serviceName = "ABQBellmarkService"

# Restart the specified service on the remote computer
try {
    Invoke-Command -ComputerName $remoteComputer -ScriptBlock {
        param($serviceName)
        Restart-Service -Name $serviceName -Force
    } -ArgumentList $serviceName -ErrorAction Stop
    Write-Host "Service $serviceName restarted successfully on $remoteComputer"
} catch {
    $errorMessage = $_.Exception.Message
    Write-Host "Failed to restart service $serviceName on $remoteComputer. $errorMessage"
    
    # Additional handling for specific error scenarios if needed
    if ($errorMessage -match "The service did not respond to the start or control request in a timely fashion") {
        Write-Host "Service start timed out. Consider checking the service status manually."
    }
    # Add more specific error handling as needed
}
