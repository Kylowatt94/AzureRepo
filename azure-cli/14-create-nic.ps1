<#
.SYNOPSIS
    Creates a network interface in Subnet1 and binds the public IP to it.

.NOTES
    Requires:   Azure CLI (az)
    Depends on: 12-create-vnet.ps1, 13-create-public-ip.ps1
#>

$ResourceGroupName = "azrgtest-eus"
$Location          = "eastus"
$VnetName          = "vnet-test-eus-01"
$SubnetName        = "Subnet1"
$PublicIpName      = "piptest-eus1"
$NicName           = "NicTest1"

az network nic create `
    --resource-group $ResourceGroupName `
    --location $Location `
    --name $NicName `
    --vnet-name $VnetName `
    --subnet $SubnetName `
    --public-ip-address $PublicIpName
