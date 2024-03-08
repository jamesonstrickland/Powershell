#$computerName = "USABQ00074712"  # Replace with the name or IP address of the remote computer

New-PSSession -ComputerName USABQ00074712 | Get-WmiObject -Class Win32_Product | Select-Object Name, Version, Vendor

if ($installedApps) {
    Write-Host "Installed Applications:"
    $installedApps
} else {
    Write-Host "No applications found"
}
