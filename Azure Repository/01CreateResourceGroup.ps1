$resourceGroupName = "RGTest"
$location           = "eastus"

if (-not (Get-AzContext)) {
    Connect-AzAccount
}

New-AzResourceGroup -Name $resourceGroupName -Location $location

Get-AzResourceGroup -Name $resourceGroupName
