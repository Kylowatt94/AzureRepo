<#
.SYNOPSIS
    Creates a static, Standard SKU IPv4 public IP address.

.NOTES
    Requires:   Azure CLI (az)
    Depends on: 11-create-resource-group.ps1
#>

$ResourceGroupName = "azrgtest-eus"
$Location          = "eastus"
$PublicIpName      = "piptest-eus1"

az network public-ip create `
    --resource-group $ResourceGroupName `
    --location $Location `
    --name $PublicIpName `
    --sku Standard `
    --allocation-method Static `
    --version IPv4
