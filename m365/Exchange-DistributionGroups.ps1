<#
.SYNOPSIS
    Reference snippets for managing Exchange Online distribution groups.

.DESCRIPTION
    A runbook of one-liners, not a script to run top-to-bottom. Copy the
    command you need and replace the placeholder names and addresses.

.NOTES
    Requires: ExchangeOnlineManagement module (see Connect-ExchangeOnlineAdmin.ps1)
#>

# Create a distribution group
New-DistributionGroup -Name "Team A" -Members user1@contoso.com, user2@contoso.com

# Add/remove a member
Add-DistributionGroupMember -Identity "Team A" -Member user@contoso.com
Remove-DistributionGroupMember -Identity "Team A" -Member user@contoso.com

# View group membership
Get-DistributionGroupMember -Identity "Team A"
