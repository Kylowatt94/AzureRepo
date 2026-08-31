Connect-MgGraph -Scopes "User.ReadWrite.All","Group.ReadWrite.All"

# Create a user
New-MgUser -DisplayName "Jane Doe" -UserPrincipalName jane@domain.com -AccountEnabled -MailNickname jane -PasswordProfile @{Password="TempPass123!"}

# Add user to group
New-MgGroupMember -GroupId <group-id> -DirectoryObjectId <user-id>

# Reset a user's password
Update-MgUser -UserId jane@domain.com -PasswordProfile @{Password="NewTempPass123!"; ForceChangePasswordNextSignIn=$true}

# Check sign-in logs for a user (troubleshooting failed logins/MFA)
Get-MgAuditLogSignIn -Filter "userPrincipalName eq 'jane@domain.com'"
