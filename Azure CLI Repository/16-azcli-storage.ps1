$ResourceGroupName = "azrgtest-eus"
$Location          = "eastus"
$StorageAccountName = "sttesteus01"
$Kind               = "StorageV2"
$Sku                = "Standard_LRS"

az storage account create `
--resource-group $ResourceGroupName `
--location $Location `
--name $StorageAccountName `
--kind $Kind `
--sku $Sku