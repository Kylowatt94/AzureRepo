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
