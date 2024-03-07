$outputcsv = "C:\Temp\Test\OpenTextStatusPerHostname.csv"
$Computers = Get-Content "C:\Temp\Test\Computers.txt"
$OutputMessage = @()
$software = "OpenText*"

ForEach ($computer in $Computers) { 
    $pingtest = Test-Connection -ComputerName $computer -Quiet -Count 1 -ErrorAction SilentlyContinue
    if($pingtest) {
        $pingtestResult = "Online"
        Try{
             $SW = Get-WmiObject Win32_Product -ComputerName $computer -ErrorAction Stop | select Name,Version | Where-Object -FilterScript {$_.Name -like $software} | Format-table
             if($SW){
                $SWResult = "$SW installed."
             }
             Else {
                $SWResult = "$software NOT installed."
             }
         }
         Catch [System.UnauthorizedAccessException]{
            $err = "Access Denied."
         }
         Catch [System.Management.ManagementException]{
            $err = "Access Denied."
         }
         Catch [System.Exception]{
            $err = "$_.Exception.GetType()"
         }
         if($err){
            $OutputMessage += "$computer,$pingtestResult,$err"
         }
         else {
            $OutputMessage += "$computer,$pingtestResult,$SWResult"
         }
      }
     else {
       $pingtestResult = "Offline"
       $OutputMessage += "$computer,Offline"
     }
    $OutputMessage | Out-File $outputcsv -Encoding utf8 -Append
 }