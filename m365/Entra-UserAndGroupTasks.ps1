<#
.SYNOPSIS
    Reference snippets for Microsoft Entra ID user and group administration
    using Microsoft Graph PowerShell.

.DESCRIPTION
    A runbook of one-liners, not a script to run top-to-bottom. Copy the
    command you need and replace the <placeholders>.

.NOTES
    Requires: Microsoft.Graph module
        Install-Module Microsoft.Graph -Scope CurrentUser
#>

Connect-MgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All", "AuditLog.Read.All"

# Create a user (forced to change the temporary password at first sign-in)
New-MgUser -DisplayName "Jane Doe" -UserPrincipalName jane@contoso.com -AccountEnabled -MailNickname jane `
    -PasswordProfile @{ Password = "<temporary-password>"; ForceChangePasswordNextSignIn = $true }

# Add a user to a group
New-MgGroupMember -GroupId "<group-id>" -DirectoryObjectId "<user-id>"

# Reset a user's password
Update-MgUser -UserId jane@contoso.com `
    -PasswordProfile @{ Password = "<temporary-password>"; ForceChangePasswordNextSignIn = $true }

# Check sign-in logs for a user (troubleshooting failed logins/MFA)
Get-MgAuditLogSignIn -Filter "userPrincipalName eq 'jane@contoso.com'"
