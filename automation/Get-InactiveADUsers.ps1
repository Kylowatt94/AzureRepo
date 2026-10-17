<#
.SYNOPSIS
    Reports enabled Active Directory accounts that have been inactive for a
    set number of days (or have never logged on).

.DESCRIPTION
    Finds stale accounts as the first step of an AD cleanup. The script is
    read-only: it builds a report and does not disable or delete anything.

    - Uses LastLogonTimestamp (replicated) to determine last activity
    - Treats never-logged-on accounts as inactive since creation
    - Skips accounts under an excluded OU (e.g. service accounts)
    - Skips members (recursive) of privileged groups
    - Exports results to a timestamped CSV and prints a summary table

.PARAMETER DomainName
    The domain (or a specific domain controller) to query.

.PARAMETER InactiveDays
    Accounts with no logon in this many days are reported. Default: 180.

.PARAMETER ExcludedOU
    Distinguished name of an OU whose accounts are always skipped.

.PARAMETER ExcludedGroups
    Groups whose members are always skipped.

.PARAMETER ReportPath
    Path of the CSV report.

.EXAMPLE
    .\Get-InactiveADUsers.ps1 -DomainName corp.contoso.com -InactiveDays 90

.NOTES
    Requires: ActiveDirectory module (RSAT) or run on a domain controller.
    LastLogonTimestamp can lag real activity by up to ~14 days by design.
#>

param(
    [string]  $DomainName     = "contoso.com",
    [int]     $InactiveDays   = 180,
    [string]  $ExcludedOU     = "OU=Service Accounts,DC=contoso,DC=com",
    [string[]]$ExcludedGroups = @("Domain Admins", "Administrators"),
    [string]  $ReportPath     = "C:\Reports\InactiveUsers-$(Get-Date -Format 'yyyyMMdd-HHmmss').csv"
)

Import-Module ActiveDirectory -ErrorAction Stop

$thresholdDate = (Get-Date).AddDays(-$InactiveDays)
Write-Host "Checking for enabled accounts with no logon since $($thresholdDate.ToString('yyyy-MM-dd')) (or never logged on)..."

# Build the set of accounts to exclude via privileged group membership
$excludedMembers = New-Object System.Collections.Generic.HashSet[string]
foreach ($groupName in $ExcludedGroups) {
    try {
        Get-ADGroupMember -Identity $groupName -Recursive -Server $DomainName -ErrorAction Stop |
            Where-Object { $_.objectClass -eq "user" } |
            ForEach-Object { $excludedMembers.Add($_.SamAccountName) | Out-Null }
    }
    catch {
        Write-Warning "Could not read group '$groupName' - skipping that exclusion. $_"
    }
}
Write-Host "Excluding $($excludedMembers.Count) accounts via admin/privileged group membership."

# Pull all enabled users
$allUsers = Get-ADUser -Server $DomainName -Filter { Enabled -eq $true } `
    -Properties LastLogonTimestamp, DistinguishedName, Description, whenCreated

Write-Host "Retrieved $($allUsers.Count) enabled user accounts from $DomainName."

# Filter the results
$results = foreach ($user in $allUsers) {

    # Skip anything under the excluded OU
    if ($user.DistinguishedName -like "*$ExcludedOU") { continue }

    # Skip anything in an excluded privileged group
    if ($excludedMembers.Contains($user.SamAccountName)) { continue }

    $neverLoggedOn = $null -eq $user.LastLogonTimestamp
    $lastLogonDate = if ($neverLoggedOn) { $null } else { [DateTime]::FromFileTime($user.LastLogonTimestamp) }

    $isInactive = $neverLoggedOn -or ($lastLogonDate -lt $thresholdDate)
    if (-not $isInactive) { continue }

    $daysInactive = if ($neverLoggedOn) {
        [int]((Get-Date) - $user.whenCreated).TotalDays
    } else {
        [int]((Get-Date) - $lastLogonDate).TotalDays
    }

    # Pull just the parent OU
    $ouPath = ($user.DistinguishedName -split ',', 2)[1]

    [PSCustomObject]@{
        SamAccountName    = $user.SamAccountName
        Name              = $user.Name
        OU                = $ouPath
        NeverLoggedOn     = $neverLoggedOn
        LastLogonDate     = $lastLogonDate
        DaysInactive      = $daysInactive
        AccountCreated    = $user.whenCreated
        Description       = $user.Description
        DistinguishedName = $user.DistinguishedName
    }
}

$results = @($results | Sort-Object DaysInactive -Descending)

# Output
if ($results.Count -eq 0) {
    Write-Host "No inactive accounts found matching the criteria."
}
else {
    $reportFolder = Split-Path $ReportPath -Parent
    if (-not (Test-Path $reportFolder)) {
        New-Item -Path $reportFolder -ItemType Directory -Force | Out-Null
    }

    $results | Export-Csv -Path $ReportPath -NoTypeInformation
    Write-Host "Found $($results.Count) inactive account(s). Report saved to: $ReportPath"
    $results | Format-Table SamAccountName, Name, NeverLoggedOn, LastLogonDate, DaysInactive -AutoSize
}
