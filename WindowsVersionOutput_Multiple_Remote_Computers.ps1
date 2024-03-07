#################
#Edit the $computers array to include one or more computers to update.  Each hostname is enclosed in "", and
#     for multiple computers you must separate each hostname with a comma.
#################

$computers = "USABQ00074574"
Foreach ($computer in $computers)
{
    #################
    #First, check to ensure the endpoint is reachable
    #################
    if (Test-Connection -ComputerName $computer -Count 1 -ErrorAction SilentlyContinue){
    #################
    #Endpoint is reachable, so process the commands
    #################
        $session=New-PSSession -ComputerName $computer
        Invoke-Command -Session $session  -ScriptBlock {
        #Get-WULastResults -ComputerName $computer.Name|select ComputerName, LastSearchSuccessDate, LastInstallationSuccessDate
        #Get-WUJob -ComputerName $computer
        Get-ComputerInfo | select WindowsProductName, WindowsVersion, OsHardwareAbstractionLayer
        }
        Get-PSSession | Remove-PSSession
    }
    else{
      #################
      #Endpoint is not reachable
      #################
      Write-Host "$computer,Down"
      }
}