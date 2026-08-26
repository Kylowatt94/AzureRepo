<#
NOTES
    This is a hard delete of the whole resource group.
#>

$resourceGroupName = "RGTest"

Remove-AzResourceGroup -Name $resourceGroupName -Force
