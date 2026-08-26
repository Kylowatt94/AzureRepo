<#
.NOTES
    256 addresses (10.0.0.0 - 10.0.0.255), split here into two /25 subnets:

        Subnet1  10.0.0.0/25    (usable range 10.0.0.4  - 10.0.0.126)
        Subnet2  10.0.0.128/25  (usable range 10.0.0.132 - 10.0.0.254)
#>

$resourceGroupName = "RGTest"
$location           = "eastus"
$vnetName           = "VnetTest"
$vnetAddressSpace   = "10.0.0.0/24"

$subnet1Name   = "Subnet1"
$subnet1Prefix = "10.0.0.0/25"

$subnet2Name   = "Subnet2"
$subnet2Prefix = "10.0.0.128/25"

# Build the subnet configs
$subnet1 = New-AzVirtualNetworkSubnetConfig -Name $subnet1Name -AddressPrefix $subnet1Prefix
$subnet2 = New-AzVirtualNetworkSubnetConfig -Name $subnet2Name -AddressPrefix $subnet2Prefix

# Create the VNet with both subnets attached
$vnet = New-AzVirtualNetwork `
    -ResourceGroupName $resourceGroupName `
    -Location $location `
    -Name $vnetName `
    -AddressPrefix $vnetAddressSpace `
    -Subnet $subnet1, $subnet2

$vnet
