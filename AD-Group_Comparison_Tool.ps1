# Import the Active Directory module
Import-Module ActiveDirectory

# Define the names of the AD groups
$group1Name = "USABQ_Manual_Patching"
$group2Name = "USABQ_Reboot_Exempt_Group"

# Get members of Group 1 and Group 2
$membersGroup1 = Get-ADGroupMember -Identity $group1Name
$membersGroup2 = Get-ADGroupMember -Identity $group2Name

# Compare members and extract those that don't match
$membersNotInGroup2 = Compare-Object -ReferenceObject $membersGroup1.SamAccountName -DifferenceObject $membersGroup2.SamAccountName |
    Where-Object { $_.SideIndicator -eq '<=' } | Select-Object -ExpandProperty SamAccountName

$membersNotInGroup1 = Compare-Object -ReferenceObject $membersGroup2.SamAccountName -DifferenceObject $membersGroup1.SamAccountName |
    Where-Object { $_.SideIndicator -eq '<=' } | Select-Object -ExpandProperty SamAccountName

# Output the results to a text file
$outputFilePath = "C:\Users\3325764\Powershell\ComparisonTool\OutputFile.txt"

# Display the labels and members not in both groups and write to the file
if ($membersNotInGroup2.Count -gt 0) {
    "Members in $group1Name but not in $group2Name" | Out-File -Append -FilePath $outputFilePath
    $membersNotInGroup2 | Out-File -Append -FilePath $outputFilePath
} else {
    "All members of $group1Name are also in $group2Name." | Out-File -Append -FilePath $outputFilePath
}

if ($membersNotInGroup1.Count -gt 0) {
    "Members in $group2Name but not in $group1Name" | Out-File -Append -FilePath $outputFilePath
    $membersNotInGroup1 | Out-File -Append -FilePath $outputFilePath
} else {
    "All members of $group2Name are also in $group1Name." | Out-File -Append -FilePath $outputFilePath
}

Write-Host "Results have been written to $outputFilePath."
