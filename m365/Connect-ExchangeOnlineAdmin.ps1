<#
.SYNOPSIS
    Connects to Exchange Online with an admin account.

.NOTES
    Requires: ExchangeOnlineManagement module
        Install-Module ExchangeOnlineManagement -Scope CurrentUser
#>

Connect-ExchangeOnline -UserPrincipalName admin@contoso.com
