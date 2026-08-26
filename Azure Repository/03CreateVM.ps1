<#
Notes broken up into sections
#>

$resourceGroupName = "RGTest"
$location           = "eastus"
$vnetName           = "VnetTest"
$subnetName         = "Subnet1"

$vmName  = "TestVM01"
$vmSize  = "Standard_B1s"
$nsgName = "$vmName-nsg"
$pipName = "$vmName-pip"
$nicName = "$vmName-nic"

# Pull the VNet/subnet 
$vnet   = Get-AzVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroupName
$subnet = Get-AzVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet

# NSG allowing inbound RDP
$rdpRule = New-AzNetworkSecurityRuleConfig `
    -Name "Allow-RDP" `
    -Description "Allow RDP inbound" `
    -Access Allow `
    -Protocol Tcp `
    -Direction Inbound `
    -Priority 100 `
    -SourceAddressPrefix "*" `
    -SourcePortRange "*" `
    -DestinationAddressPrefix "*" `
    -DestinationPortRange 3389

$nsg = New-AzNetworkSecurityGroup `
    -ResourceGroupName $resourceGroupName `
    -Location $location `
    -Name $nsgName `
    -SecurityRules $rdpRule

# Public IP
$pip = New-AzPublicIpAddress `
    -ResourceGroupName $resourceGroupName `
    -Location $location `
    -Name $pipName `
    -AllocationMethod Static `
    -Sku Standard

# NIC
$nic = New-AzNetworkInterface `
    -ResourceGroupName $resourceGroupName `
    -Location $location `
    -Name $nicName `
    -SubnetId $subnet.Id `
    -PublicIpAddressId $pip.Id `
    -NetworkSecurityGroupId $nsg.Id

# Local admin credentials for the VM
$cred = Get-Credential -Message "Password12345! $vmName"

#  VM configuration
$vmConfig = New-AzVMConfig -VMName $vmName -VMSize $vmSize |
    Set-AzVMOperatingSystem -Windows -ComputerName $vmName -Credential $cred |
    Set-AzVMSourceImage -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2022-datacenter-azure-edition" -Version "latest" |
    Add-AzVMNetworkInterface -Id $nic.Id

#  Deploy 
New-AzVM -ResourceGroupName $resourceGroupName -Location $location -VM $vmConfig

Write-Host "`nDone. Connect with:  mstsc /v:$($pip.IpAddress)" -ForegroundColor Green
