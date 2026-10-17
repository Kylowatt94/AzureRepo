<#
.SYNOPSIS
    Creates a general-purpose v2 storage account (also used for VM boot diagnostics).

.NOTES
    Requires:   Azure CLI (az)
    Depends on: 11-create-resource-group.ps1
#>

$ResourceGroupName  = "azrgtest-eus"
$Location           = "eastus"
$StorageAccountName = "sttesteus01"
$Kind               = "StorageV2"
$Sku                = "Standard_LRS"

az storage account create `
    --resource-group $ResourceGroupName `
    --location $Location `
    --name $StorageAccountName `
    --kind $Kind `
    --sku $Sku
