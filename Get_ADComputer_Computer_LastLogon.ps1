 #$computers = Get-Content -Path "C:\Temp\Test\ENC_Computers.txt"
 $computers = "USABQ00041877"
 foreach ($computer in $computers) {
 Get-ADComputer -Filter {name -eq $computer} -SearchBase “DC=corp,DC=JABIL,DC=ORG” -Properties * | Sort LastLogon | Select Name, LastLogonDate,@{Name='LastLogon';Expression={[DateTime]::FromFileTime($_.LastLogon)}} #| Export-Csv C:\Temp\TEST\ENC_adcomputers-last-logon.csv -NoType -Append
 	
 $scopes = Get-DhcpServerv4Scope -ComputerName "USABQM0DHCP01"
 foreach ($scope in $scopes){
    Get-DhcpServerv4Lease -ScopeId $scope.ScopeID -ComputerName "USABQM0DHCP01" | Where-Object Hostname -eq $computer
    }
}



