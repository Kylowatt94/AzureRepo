<#
.SYNOPSIS
    Creates an NSG with inbound SSH and HTTP rules and associates it with Subnet1.

.NOTES
    Requires:   Azure CLI (az)
    Depends on: 12-create-vnet.ps1

    For anything beyond a lab, restrict the SSH rule's source to a trusted
    admin IP instead of "Internet".
#>

$ResourceGroupName = "azrgtest-eus"
$Location          = "eastus"
$NsgName           = "nsgtest-eus1"
$VnetName          = "vnet-test-eus-01"
$SubnetName        = "Subnet1"

az network nsg create `
    --resource-group $ResourceGroupName `
    --location $Location `
    --name $NsgName

az network nsg rule create `
    --resource-group $ResourceGroupName `
    --nsg-name $NsgName `
    --name Allow-SSH-from-Internet `
    --priority 100 `
    --direction Inbound `
    --protocol Tcp `
    --source-address-prefixes Internet `
    --source-port-ranges '*' `
    --destination-address-prefixes '*' `
    --destination-port-ranges 22

az network nsg rule create `
    --resource-group $ResourceGroupName `
    --nsg-name $NsgName `
    --name Allow-HTTP-from-Internet `
    --priority 101 `
    --direction Inbound `
    --protocol Tcp `
    --source-address-prefixes Internet `
    --source-port-ranges '*' `
    --destination-address-prefixes '*' `
    --destination-port-ranges 80

az network vnet subnet update `
    --resource-group $ResourceGroupName `
    --vnet-name $VnetName `
    --name $SubnetName `
    --network-security-group $NsgName
