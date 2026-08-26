<#
.SYNOPSIS
    Lab step 3: creates a Windows Server test VM (TestVM01) in Subnet1 of
    VnetTest, with its own NSG, public IP, and NIC.

.NOTES
    - VM size defaults to Standard_B1s (Azure free-tier eligible - cheap to leave running, still cheap to forget about).
    - Image defaults to Windows Server 2022 Datacenter (Azure Edition).
    - You'll be prompted for a local admin username/password via Get-Credential.
    - SECURITY: the NSG rule below opens RDP (3389) from ANY source, which is
      fine for a short-lived lab but not something to leave running. For
      anything longer-lived, replace "*" in -SourceAddressPrefix with your
      own public IP, or better, use Azure Bastion instead of a public IP at all.
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

# --- Pull the VNet/subnet created in step 2 ---
$vnet   = Get-AzVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroupName
$subnet = Get-AzVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet

# --- NSG allowing inbound RDP ---
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

# --- Public IP ---
$pip = New-AzPublicIpAddress `
    -ResourceGroupName $resourceGroupName `
    -Location $location `
    -Name $pipName `
    -AllocationMethod Static `
    -Sku Standard

# --- NIC (bound to Subnet1, the NSG, and the public IP) ---
$nic = New-AzNetworkInterface `
    -ResourceGroupName $resourceGroupName `
    -Location $location `
    -Name $nicName `
    -SubnetId $subnet.Id `
    -PublicIpAddressId $pip.Id `
    -NetworkSecurityGroupId $nsg.Id

# --- Local admin credentials for the VM ---
$cred = Get-Credential -Message "Enter local admin username/password for $vmName"

# --- VM configuration ---
$vmConfig = New-AzVMConfig -VMName $vmName -VMSize $vmSize |
    Set-AzVMOperatingSystem -Windows -ComputerName $vmName -Credential $cred |
    Set-AzVMSourceImage -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2022-datacenter-azure-edition" -Version "latest" |
    Add-AzVMNetworkInterface -Id $nic.Id

# --- Deploy ---
New-AzVM -ResourceGroupName $resourceGroupName -Location $location -VM $vmConfig

Write-Host "`nDone. Connect with:  mstsc /v:$($pip.IpAddress)" -ForegroundColor Green
