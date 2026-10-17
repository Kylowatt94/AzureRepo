<#
.SYNOPSIS
    Creates a /16 virtual network with a single /24 subnet.

.NOTES
    Requires:   Azure CLI (az)
    Depends on: 11-create-resource-group.ps1
#>

$ResourceGroupName   = "azrgtest-eus"
$Location            = "eastus"
$VnetName            = "vnet-test-eus-01"
$AddressSpace        = "10.0.0.0/16"
$SubnetName          = "Subnet1"
$SubnetAddressPrefix = "10.0.0.0/24"

az network vnet create `
    --resource-group $ResourceGroupName `
    --location $Location `
    --name $VnetName `
    --address-prefixes $AddressSpace `
    --subnet-name $SubnetName `
    --subnet-prefixes $SubnetAddressPrefix
