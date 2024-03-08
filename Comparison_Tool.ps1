# Import the Active Directory module
Import-Module ActiveDirectory

# Define the names of the AD groups
$group1Name = "USABQ_Reboot_Exempt_Group"
$group2Name = "USABQ_Manual_Patching"

# Get members of Group 1 and Group 2
$membersGroup1 = Get-ADGroupMember -Identity $group1Name
$membersGroup2 = Get-ADGroupMember -Identity $group2Name

# Compare members and extract those that don't match
$membersNotInGroup2 = Compare-Object -ReferenceObject $membersGroup1 -DifferenceObject $membersGroup2 -Property SamAccountName -PassThru |
    Where-Object { $_.SideIndicator -eq '<=' }

$membersNotInGroup1 = Compare-Object -ReferenceObject $membersGroup2 -DifferenceObject $membersGroup1 -Property SamAccountName -PassThru |
    Where-Object { $_.SideIndicator -eq '<=' }

# Display the members not in both groups
if ($membersNotInGroup2.Count -gt 0) {
    Write-Host "Members in $group1Name but not in $group2Name"
    $membersNotInGroup2 | Select-Object SamAccountName
} else {
    Write-Host "All members of $group1Name are also in $group2Name."
}

if ($membersNotInGroup1.Count -gt 0) {
    Write-Host "Members in $group2Name but not in $group1Name"
    $membersNotInGroup1 | Select-Object SamAccountName
} else {
    Write-Host "All members of $group2Name are also in $group1Name."
}