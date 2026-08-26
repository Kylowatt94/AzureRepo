$ResourceGroupName = "azrgtest-eus"
$Location          = "eastus"
$NsgName           = "nsgtest-eus1"
$VnetName          = "vnet-test-eus-01"
$SubnetName        = "Subnet1"

az network nsg create `
--resource-group $ResourceGroupName `
--location $Location `
--name $NsgName `

az network nsg rule create `
--resource-group $ResourceGroupName `
--nsg-name $NsgName `
--name Allow-HTTP `
--priority 100 `
--direction Inbound `
--protocol Tcp `
--source-address-prefixes Internet `
--source-port-ranges '*' `
--destination-address-prefixes "10.0.0.1" `
--destination-port-ranges 22 `

az network nsg rule create `
--resource-group $ResourceGroupName `
--nsg-name $NsgName `
--name Allow-HTTP-from-Internet-to-10.0.0.1 `
--priority 101 `
--direction Inbound `
--protocol Tcp `
--source-address-prefixes Internet `
--source-port-ranges '*' `
--destination-address-prefixes "10.0.0.1" `
--destination-port-ranges 80 `

az network vnet subnet update `
--resource-group $ResourceGroupName `
--vnet-name $VnetName `
--name $SubnetName `
--network-security-group $NsgName
