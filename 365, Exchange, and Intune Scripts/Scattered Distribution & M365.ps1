# Create a distribution group
New-DistributionGroup -Name "Team A" -Members user1@domain.com,user2@domain.com

# Add/remove member
Add-DistributionGroupMember -Identity "Team A" -Member user@domain.com
Remove-DistributionGroupMember -Identity "Team A" -Member user@domain.com

# View group membership
Get-DistributionGroupMember -Identity "Team A"
