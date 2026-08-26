$ResourceGroupName = "RGTest"
$Location           = "eastus"
$NsgName            = "NSGTest"
$vnetName           = "VnetTest"
$subnetName         = "Subnet1"
$AdminSourceIP      = "My.Public.Ip/32"

# HTTP from the Internet
$AllowHttp = New-AzNetworkSecurityRuleConfig -Name "in-allow-http-from-internet" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 `
    -SourceAddressPrefix Internet -SourcePortRange * `
    -DestinationAddressPrefix * -DestinationPortRange 80

# SSH
$AllowSsh = New-AzNetworkSecurityRuleConfig -Name "in-allow-ssh-admin" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 110 `
    -SourceAddressPrefix $AdminSourceIP -SourcePortRange * `
    -DestinationAddressPrefix * -DestinationPortRange 22

# NSG
$Nsg = New-AzNetworkSecurityGroup -Name $NsgName `
    -ResourceGroupName $ResourceGroupName `
    -Location $Location `
    -SecurityRules $AllowHttp, $AllowSsh

# Attaches the NSG
$vnet = Get-AzVirtualNetwork -Name $vnetName -ResourceGroupName $ResourceGroupName

Set-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $subnetName `
    -AddressPrefix "10.0.0.0/25" -NetworkSecurityGroup $Nsg | Out-Null

Set-AzVirtualNetwork -VirtualNetwork $vnet
