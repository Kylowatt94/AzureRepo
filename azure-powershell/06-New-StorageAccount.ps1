<#
.SYNOPSIS
    Creates a general-purpose v2 storage account with locally redundant storage.

.NOTES
    Requires:   Az.Storage
    Depends on: 01-New-ResourceGroup.ps1

    Storage account names must be globally unique, 3-24 characters,
    lowercase letters and numbers only.
#>

$ResourceGroupName  = "RGTest"
$StorageAccountName = "stacctest01"
$Location           = "eastus"
$Kind               = "StorageV2"
$Sku                = "Standard_LRS"

New-AzStorageAccount -ResourceGroupName $ResourceGroupName `
    -Name $StorageAccountName `
    -Location $Location `
    -Kind $Kind `
    -SkuName $Sku
