<#
.SYNOPSIS
    Tears down the entire lab by deleting the resource group.

.DESCRIPTION
    This is a hard delete of the resource group and EVERYTHING in it.
    Run it when you are finished with the lab to stop incurring charges.

.NOTES
    Requires: Az.Resources
#>

$resourceGroupName = "RGTest"

Remove-AzResourceGroup -Name $resourceGroupName -Force
