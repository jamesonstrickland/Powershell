#################
#Edit the $computers array to include one or more computers to update.  Each hostname is enclosed in "", and
#     for multiple computers you must separate each hostname with a comma.
#################

$computers = "USABQ00073527"#,"USABQ00073455","USABQ00073607"

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
        # NOTE:  Ensure -Credential is followed by "JABIL\<Your NTID>"
        $session=New-PSSession -ComputerName $computer -Credential JABIL\2878498
        Invoke-Command -Session $session  -ScriptBlock {
        [Net.servicepointmanager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
                Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
                Install-Module PSWindowsUpdate -Force -AllowClobber
                Import-Module PSWindowsUpdate; Enable-WURemoting
    #################
    #To upgrade via Upgrade Assistant:
        $dir = 'C:\Temp\Packages'
        mkdir $dir
        $webClient = New-Object System.Net.WebClient
        $url = 'https://go.microsoft.com/fwlink/?LinkID=799445'
        $file = "$($dir)\Windows10Upgrade9252.exe"
        $webClient.DownloadFile($url,$file)
        Start-Process -FilePath $file -ArgumentList '/quietinstall /skipeula /autoupgrade /copylogs $dir'

        #Get-WURebootStatus

        Get-PSSession | Remove-PSSession}
      }
      else{
      #################
      #Endpoint is not reachable
      #################
      Write-Host "$computer,Down"
      }
}