$ResourceGroupName = "azrgtest-eus"
$Location          = "eastus"
$VnetName          = "vnet-test-eus-01"
$SubnetName        = "Subnet1"
$PublicIpName      = "piptest-eus1"
$NicName           = "NicTest1"

az network nic create  `
--resource-group $ResourceGroupName `
--location $Location `
--name $NicName `
--vnet-name $VnetName `
--subnet $SubnetName `
--public-ip-address $PublicIpName