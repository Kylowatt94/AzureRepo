<#
    Lab step 1: creates the resource group everything else in this lab lives in.

NOTES
    - Location defaults to "eastus". Change $location if you want a different region.
    - Run Connect-AzAccount once per PowerShell session before running these scripts.
#>

$resourceGroupName = "RGTest"
$location           = "eastus"

if (-not (Get-AzContext)) {
    Connect-AzAccount
}

New-AzResourceGroup -Name $resourceGroupName -Location $location

Get-AzResourceGroup -Name $resourceGroupName
