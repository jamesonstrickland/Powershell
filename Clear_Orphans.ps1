# Replace 'RemoteComputer' with the actual hostname or IP address of the remote PC
$remoteComputer = 'azuse2belmrk01'
$credential = Get-Credential  # Enter credentials for the remote machine

# Define the list of directories to clear on the remote PC
$directoriesToClear = @(
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
)

# Create a PSSession to the remote machine
$remoteSession = New-PSSession -ComputerName $remoteComputer -Credential $credential

# Loop through each directory on the remote PC and clear its contents
foreach ($directory in $directoriesToClear) {
    Write-Host "Clearing contents of $directory on $remoteComputer..."
    
    # Clear the contents of the directory on the remote PC
    Invoke-Command -Session $remoteSession -ScriptBlock {
        param($dir)
        Get-ChildItem -Path $dir | Remove-Item -Recurse -Force
    } -ArgumentList $directory

    Write-Host "Contents cleared.`n"
}

# Close the remote session
Remove-PSSession -Session $remoteSession