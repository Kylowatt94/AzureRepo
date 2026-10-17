<#
.SYNOPSIS
    Creates the resource group for the Azure CLI lab.

.NOTES
    Requires: Azure CLI (az), signed in with `az login`
#>

$ResourceGroupName = "azrgtest-eus"
$Location          = "eastus"

az group create --name $ResourceGroupName --location $Location
