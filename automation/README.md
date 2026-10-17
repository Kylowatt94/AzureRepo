# Automation Scripts

Sanitized versions of scripts written for and used in production environments.

## [`Get-InactiveADUsers.ps1`](Get-InactiveADUsers.ps1)

Reports enabled AD accounts with no logon in *N* days (default 180), or no logon ever.

- Excludes a service-account OU and members of privileged groups (recursive)
- Calculates days inactive, falling back to the account creation date for never-used accounts
- Exports a timestamped CSV sorted by days inactive
- **Read-only:** it changes nothing in AD

```powershell
.\Get-InactiveADUsers.ps1 -DomainName corp.contoso.com -InactiveDays 90 -ReportPath C:\Reports\stale.csv
```

## [`Install-Office2019.ps1`](Install-Office2019.ps1)

Unattended Office 2019 Pro Plus (VL, x64) deployment using the Office Deployment Tool.

- Generates its own uninstall/install XML configs at runtime
- Removes existing Click-to-Run Office before installing
- Verifies the install in the registry
- Logs to `C:\Logs\OfficeDeploy` and returns the ODT exit code, which suits RMM/SCCM/Intune deployments

Set `$SourceRoot` to your software share, then run it from an elevated PowerShell session.
