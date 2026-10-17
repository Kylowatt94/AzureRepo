<#
.SYNOPSIS
    Reference snippets for common Exchange Online mailbox administration tasks.

.DESCRIPTION
    A runbook of one-liners, not a script to run top-to-bottom. Copy the
    command you need and replace the placeholder addresses.

.NOTES
    Requires: ExchangeOnlineManagement module (see Connect-ExchangeOnlineAdmin.ps1)
#>

# View mailbox details
Get-Mailbox -Identity user@contoso.com

# Check mailbox size/usage
Get-MailboxStatistics -Identity user@contoso.com | Select-Object DisplayName, TotalItemSize, ItemCount

# Convert a user mailbox to a shared mailbox (e.g. offboarding)
Set-Mailbox -Identity user@contoso.com -Type Shared

# Grant Full Access permission
Add-MailboxPermission -Identity user@contoso.com -User delegate@contoso.com -AccessRights FullAccess -InheritanceType All

# Grant Send As
Add-RecipientPermission -Identity user@contoso.com -Trustee delegate@contoso.com -AccessRights SendAs

# Forward mail to another address while keeping a copy in the mailbox
Set-Mailbox -Identity user@contoso.com -ForwardingSmtpAddress other@contoso.com -DeliverToMailboxAndForward $true

# Set an out-of-office reply
Set-MailboxAutoReplyConfiguration -Identity user@contoso.com -AutoReplyState Enabled `
    -InternalMessage "I am currently out of the office." `
    -ExternalMessage "I am currently out of the office."
