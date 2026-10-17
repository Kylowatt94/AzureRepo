<#
.SYNOPSIS
    Creates a subnet-level NSG (HTTP from the Internet, SSH from an admin IP)
    and associates it with Subnet1.

.DESCRIPTION
    Step 4 of the Az PowerShell lab. Demonstrates locking management access
    (SSH) to a single trusted source IP while leaving web traffic open.

.NOTES
    Requires:   Az.Network
    Depends on: 02-New-VirtualNetwork.ps1

    Set $AdminSourceIP to your own public IP (CIDR /32) before running.
#>

$ResourceGroupName = "RGTest"
$Location          = "eastus"
$NsgName           = "NSGTest"
$vnetName          = "VnetTest"
$subnetName        = "Subnet1"
$AdminSourceIP     = "<your-public-ip>/32"

# HTTP from the Internet
$AllowHttp = New-AzNetworkSecurityRuleConfig -Name "in-allow-http-from-internet" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 `
    -SourceAddressPrefix Internet -SourcePortRange * `
    -DestinationAddressPrefix * -DestinationPortRange 80

# SSH from the admin IP only
$AllowSsh = New-AzNetworkSecurityRuleConfig -Name "in-allow-ssh-admin" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 110 `
    -SourceAddressPrefix $AdminSourceIP -SourcePortRange * `
    -DestinationAddressPrefix * -DestinationPortRange 22

# NSG
$Nsg = New-AzNetworkSecurityGroup -Name $NsgName `
    -ResourceGroupName $ResourceGroupName `
    -Location $Location `
    -SecurityRules $AllowHttp, $AllowSsh

# Attach the NSG to the subnet
$vnet = Get-AzVirtualNetwork -Name $vnetName -ResourceGroupName $ResourceGroupName

Set-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $subnetName `
    -AddressPrefix "10.0.0.0/25" -NetworkSecurityGroup $Nsg | Out-Null

Set-AzVirtualNetwork -VirtualNetwork $vnet
