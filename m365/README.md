# Microsoft 365: Exchange Online & Entra ID

Runbook snippets for day-to-day Microsoft 365 administration. These are collections of commands to copy as needed, not scripts to run top to bottom.

| Script | Covers |
| --- | --- |
| [`Connect-ExchangeOnlineAdmin.ps1`](Connect-ExchangeOnlineAdmin.ps1) | Connecting to Exchange Online |
| [`Exchange-MailboxTasks.ps1`](Exchange-MailboxTasks.ps1) | Mailbox details and size, shared mailbox conversion, Full Access / Send As, forwarding, out-of-office |
| [`Exchange-DistributionGroups.ps1`](Exchange-DistributionGroups.ps1) | Creating distribution groups and managing their membership |
| [`Entra-UserAndGroupTasks.ps1`](Entra-UserAndGroupTasks.ps1) | Creating users, group membership, password resets, sign-in log troubleshooting (Microsoft Graph) |

**Prerequisites:**

```powershell
Install-Module ExchangeOnlineManagement, Microsoft.Graph -Scope CurrentUser
```
