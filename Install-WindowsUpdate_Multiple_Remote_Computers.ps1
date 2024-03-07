#################
#Edit the $computers array to include one or more computers to update.  Each hostname is enclosed in "", and
#     for multiple computers you must separate each hostname with a comma.
#################

$computers = "USABQ00041879"

#################
#Loop through each hostname in $computers and invoke Windows Update
#################
foreach ($computer in $computers)
{
    #################
    #First, check to ensure the endpoint is reachable
    #################
    if (Test-Connection -ComputerName $computer -Count 1 -ErrorAction SilentlyContinue){
    #################
    #Endpoint is reachable, so process the commands
    #################
        $session=New-PSSession -ComputerName $computer -Credential JABIL\2878498
        Invoke-Command -Session $session  -ScriptBlock {
        [Net.servicepointmanager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
                Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
                Install-Module PSWindowsUpdate -Force -AllowClobber
                Import-Module PSWindowsUpdate; Enable-WURemoting
    #################
    #To install all available updates:
        Invoke-WuJob -ComputerName $computer -Script { ipmo PSWindowsUpdate; Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -Install | Out-File "C:\Windows\PSWindowsUpdate.log" -Force } -RunNow -Confirm:$false -Verbose -ErrorAction Ignore
    #Comment out above line if you need to install specific KB update(s)
    #################
    #To install specific KB update(s):
        #From 1909, roll up to 20H2:
        #Invoke-WuJob -ComputerName $computer -Script { ipmo PSWindowsUpdate; Get-WindowsUpdate -KBArticleID KB4594440 -Install -Verbose | Out-File "C:\Windows\PSWindowsUpdate.log" -Force } -RunNow -Confirm:$false -Verbose -ErrorAction Ignore
    #Comment out above line(s) if you need to install all available updates
    #################

        }
    #################
    #If the task is scheduled it should indicate the Actions, State, and TaskName for the specified computer, "PSComputerName"
    #################
        $cim = New-CimSession -ComputerName $computer
        $cim
        Get-ScheduledTask -TaskPath "\" -CimSession $cim -TaskName PSWindowsUpdate
    #################
    #Check the status of the job
    #################
        Invoke-Command -Session $session  -ScriptBlock {
        #Get-WULastResults -ComputerName $computer.Name|select ComputerName, LastSearchSuccessDate, LastInstallationSuccessDate
        Get-WUJob -ComputerName $computer
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