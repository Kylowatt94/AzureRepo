# Azure Lab: Az PowerShell

Builds a small Azure environment with the Az PowerShell module. Run the scripts in order.

| # | Script | Creates |
| --- | --- | --- |
| 01 | [`01-New-ResourceGroup.ps1`](01-New-ResourceGroup.ps1) | Resource group `RGTest` in East US |
| 02 | [`02-New-VirtualNetwork.ps1`](02-New-VirtualNetwork.ps1) | VNet `10.0.0.0/24` split into two `/25` subnets |
| 03 | [`03-New-WindowsVM.ps1`](03-New-WindowsVM.ps1) | Windows Server 2022 VM with public IP, NIC, and RDP NSG |
| 04 | [`04-New-NetworkSecurityGroup.ps1`](04-New-NetworkSecurityGroup.ps1) | Subnet NSG: HTTP from the Internet, SSH from an admin IP only |
| 05 | [`05-Add-DataDisk.ps1`](05-Add-DataDisk.ps1) | 256 GB managed data disk attached to the VM |
| 06 | [`06-New-StorageAccount.ps1`](06-New-StorageAccount.ps1) | StorageV2 / Standard_LRS storage account |
| 99 | [`99-Remove-Lab.ps1`](99-Remove-Lab.ps1) | **Deletes** the resource group and everything in it |

## Network layout

```
RGTest (eastus)
└── VnetTest            10.0.0.0/24
    ├── Subnet1         10.0.0.0/25    ← NSGTest, TestVM01
    └── Subnet2         10.0.0.128/25
```

**Prerequisites:** `Install-Module Az` and `Connect-AzAccount`
