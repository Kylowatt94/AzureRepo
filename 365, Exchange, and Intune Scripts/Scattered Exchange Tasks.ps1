# View mailbox details
Get-Mailbox -Identity user@domain.com

# Check mailbox size/usage
Get-MailboxStatistics -Identity user@domain.com | Select DisplayName, TotalItemSize, ItemCount

# Convert user mailbox to shared mailbox
Set-Mailbox -Identity user@domain.com -Type Shared

# Grant Full Access permission
Add-MailboxPermission -Identity user@domain.com -User delegate@domain.com -AccessRights FullAccess -InheritanceType All

# Grant Send As
Add-RecipientPermission -Identity user@domain.com -Trustee delegate@domain.com -AccessRights SendAs

# Set an out-of-office / forwarding
Set-Mailbox -Identity user@domain.com -ForwardingSmtpAddress other@domain.com -DeliverToMailboxAndForward $true
