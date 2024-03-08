# Replace 'RemoteComputer' with the actual hostname or IP address of the remote PC
$remoteComputer = 'azuse2belmrk01'
$credential = Get-Credential  # Enter credentials for the remote machine

# Define the list of directories to check on the remote PC
$directoriesToCheck = @(
    "\\Azuse2belmrk01\BellMark\WEESUSMJ04R82U\artwork"
    "\\Azuse2belmrk01\BellMark\WEESUSMJ04R82W\artwork",
    "\\Azuse2belmrk01\BellMark\WEESUSMJ06W7TP\artwork",
    "\\Azuse2belmrk01\BellMark\WEESUSMJ06W7TN\artwork",
    "\\Azuse2belmrk01\BellMark\WEESUSMJ34BCH\artwork",
    "\\Azuse2belmrk01\BellMark\WEESUSMJ39KEB\artwork",
    "\\Azuse2belmrk01\BellMark\WEESUSMJ39KEC\artwork",
    "\\Azuse2belmrk01\BellMark\WEESUSMJ39KED\artwork",
    "\\Azuse2belmrk01\BellMark\WEESUSMJ04R82U\HD_Printing",
    "\\Azuse2belmrk01\BellMark\WEESUSMJ04R82W\HD_Printing",
    "\\Azuse2belmrk01\BellMark\WEESUSMJ06W7TP\HD_Printing",
    "\\Azuse2belmrk01\BellMark\WEESUSMJ06W7TN\HD_Printing",
    "\\Azuse2belmrk01\BellMark\WEESUSMJ34BCH\HD_Printing",
    "\\Azuse2belmrk01\BellMark\WEESUSMJ39KEB\HD_Printing",
    "\\Azuse2belmrk01\BellMark\WEESUSMJ39KEC\HD_Printing",
    "\\Azuse2belmrk01\BellMark\WEESUSMJ39KED\HD_Printing"
    # ... add paths for other directories
)

# Create a PSSession to the remote machine
$remoteSession = New-PSSession -ComputerName $remoteComputer -Credential $credential

# Loop through each directory on the remote PC
foreach ($directory in $directoriesToCheck) {
    Write-Host "Files in $directory on $remoteComputer"
    
    # Get the list of files in the directory on the remote PC
    $files = Invoke-Command -Session $remoteSession -ScriptBlock {
        param($dir)
        Get-ChildItem -Path $dir | Where-Object { $_.PSIsContainer -eq $false }
    } -ArgumentList $directory

    # Output the list of files
    $files | ForEach-Object {
        Write-Host $_.Name
    }

    Write-Host "`n"
}

# Close the remote session
Remove-PSSession -Session $remoteSession
