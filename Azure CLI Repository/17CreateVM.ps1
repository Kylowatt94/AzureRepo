$ResourceGroupName = "azrgtest-eus"
$Location          = "eastus"

$AvSetName         = "avsettest-eus-01"
$DataDiskName      = "datadisktest-eus-01"

$VmName            = "vmtest-eus-01"
$VmSize            = "Standard_D2s_v3"
$NicName           = "nictest-eus-01"
$StorageAccountName = "sttesteus01"

az vm availability-set create `
--resource-group $ResourceGroupName `
--name $AvSetName `
--location $Location `
--platform-fault-domain-count 2 `
--platform-update-domain-count 5

az disk create `
--resource-group $ResourceGroupName `
--location $Location `
--name $DataDiskName `
--size-gb 16 `
--sku StandardSSD_LRS

az network vnet create `
--resource-group $ResourceGroupName `
--location $Location `
--name vnettest-eus1 `
--address-prefix 10.0.0.0/24 `
--subnet-name Subnet1 `
--subnet-prefix 10.0.0.0/25

az network nic create `
--resource-group $ResourceGroupName `
--name $NicName `
--vnet-name vnettest-eus1 `
--subnet Subnet1

az vm create `
--resource-group $ResourceGroupName `
--location $Location `
--name $VmName `
--nics $NicName `
  --size $VmSize `
--availability-set $AvSetName `
--admin-username azureuser `
--authentication-type ssh `
--generate-ssh-keys `
  --image "Canonical:Ubuntu-24_04-lts:server:latest" `

az vm disk attach `
--resource-group $ResourceGroupName `
--vm-name $VmName `
--name $DataDiskName `
--lun 0 `
--caching ReadWrite

az vm boot-diagnostics enable `
--resource-group $ResourceGroupName `
--name $VmName `
--storage "https://$StorageAccountName.blob.core.windows.net/"
