<#
.SYNOPSIS
    Creates the resource group for the Azure PowerShell lab.

.DESCRIPTION
    Step 1 of the Az PowerShell lab. Signs in to Azure if there is no active
    context, creates the resource group, and displays it to confirm.

.NOTES
    Requires: Az PowerShell module (Az.Accounts, Az.Resources)
#>

$resourceGroupName = "RGTest"
$location          = "eastus"

if (-not (Get-AzContext)) {
    Connect-AzAccount
}

New-AzResourceGroup -Name $resourceGroupName -Location $location

Get-AzResourceGroup -Name $resourceGroupName
