# Get all active PowerShell sessions
$activeSessions = Get-PSSession

# Check if there are active sessions
if ($activeSessions) {
    # Terminate all active sessions
    $activeSessions | Remove-PSSession -Force
    Write-Host "All active PowerShell sessions terminated."
} else {
    Write-Host "No active PowerShell sessions found."
}
