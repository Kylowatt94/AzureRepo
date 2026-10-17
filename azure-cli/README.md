# Azure Lab: Azure CLI

Builds an Azure environment with the Azure CLI (`az`), called from PowerShell. Run the scripts in order.

| # | Script | Creates |
| --- | --- | --- |
| 11 | [`11-create-resource-group.ps1`](11-create-resource-group.ps1) | Resource group `azrgtest-eus` in East US |
| 12 | [`12-create-vnet.ps1`](12-create-vnet.ps1) | VNet `10.0.0.0/16` with Subnet1 `10.0.0.0/24` |
| 13 | [`13-create-public-ip.ps1`](13-create-public-ip.ps1) | Static Standard SKU public IP |
| 14 | [`14-create-nic.ps1`](14-create-nic.ps1) | NIC in Subnet1 bound to the public IP |
| 15 | [`15-create-nsg.ps1`](15-create-nsg.ps1) | NSG with SSH/HTTP inbound rules, associated with Subnet1 |
| 16 | [`16-create-storage-account.ps1`](16-create-storage-account.ps1) | StorageV2 account (also used for boot diagnostics) |
| 17 | [`17-create-linux-vm.ps1`](17-create-linux-vm.ps1) | Ubuntu 24.04 VM in an availability set, with a data disk and boot diagnostics |

Script 17 creates its own VNet and NIC, so it only needs scripts 11 and 16.

## Result

![Resources deployed by the Azure CLI lab](../docs/images/azure-cli-deployment.png)

**Prerequisites:** [Install the Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) and run `az login`

**Cleanup:** `az group delete --name azrgtest-eus --yes`
