<#
.SYNOPSIS
    Creates a /24 virtual network split into two /25 subnets.

.DESCRIPTION
    Step 2 of the Az PowerShell lab. Address plan:

        VNet     10.0.0.0/24    (256 addresses)
        Subnet1  10.0.0.0/25    (usable range 10.0.0.4   - 10.0.0.126)
        Subnet2  10.0.0.128/25  (usable range 10.0.0.132 - 10.0.0.254)

    Azure reserves the first four and the last address in every subnet.

.NOTES
    Requires:   Az.Network
    Depends on: 01-New-ResourceGroup.ps1
#>

$resourceGroupName = "RGTest"
$location          = "eastus"
$vnetName          = "VnetTest"
$vnetAddressSpace  = "10.0.0.0/24"

$subnet1Name   = "Subnet1"
$subnet1Prefix = "10.0.0.0/25"

$subnet2Name   = "Subnet2"
$subnet2Prefix = "10.0.0.128/25"

# Subnet configs
$subnet1 = New-AzVirtualNetworkSubnetConfig -Name $subnet1Name -AddressPrefix $subnet1Prefix
$subnet2 = New-AzVirtualNetworkSubnetConfig -Name $subnet2Name -AddressPrefix $subnet2Prefix

$vnet = New-AzVirtualNetwork `
    -ResourceGroupName $resourceGroupName `
    -Location $location `
    -Name $vnetName `
    -AddressPrefix $vnetAddressSpace `
    -Subnet $subnet1, $subnet2

$vnet
