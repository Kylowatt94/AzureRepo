<#
.SYNOPSIS
    Deploys a Windows Server 2022 VM with a public IP, NIC, and RDP-enabled NSG.

.DESCRIPTION
    Step 3 of the Az PowerShell lab. Builds the networking pieces for the VM
    (NSG, static public IP, NIC in Subnet1), prompts for local admin
    credentials, then deploys the VM and prints the RDP command to connect.

.NOTES
    Requires:   Az.Compute, Az.Network
    Depends on: 02-New-VirtualNetwork.ps1

    The RDP rule allows any source address. That is fine for a short-lived
    lab, but in production restrict SourceAddressPrefix or use Azure Bastion.
#>

$resourceGroupName = "RGTest"
$location          = "eastus"
$vnetName          = "VnetTest"
$subnetName        = "Subnet1"

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
$cred = Get-Credential -Message "Enter local administrator credentials for $vmName"

# VM configuration
$vmConfig = New-AzVMConfig -VMName $vmName -VMSize $vmSize |
    Set-AzVMOperatingSystem -Windows -ComputerName $vmName -Credential $cred |
    Set-AzVMSourceImage -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2022-datacenter-azure-edition" -Version "latest" |
    Add-AzVMNetworkInterface -Id $nic.Id

# Deploy
New-AzVM -ResourceGroupName $resourceGroupName -Location $location -VM $vmConfig

Write-Host "`nDone. Connect with:  mstsc /v:$($pip.IpAddress)" -ForegroundColor Green
