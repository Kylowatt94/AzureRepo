<#
.SYNOPSIS
    Teardown: deletes RGTest and everything inside it (VNet, VM, NIC, NSG,
    public IP, disks - all of it) so you can rebuild the lab from scratch
    next time you want to practice.

.NOTES
    This is a hard delete of the whole resource group. There's no confirm
    prompt beyond -Force below - if you only want to delete one piece
    (e.g. just the VM to try a redeploy), use the matching Remove-Az* cmdlet
    instead (Remove-AzVM, Remove-AzVirtualNetwork, etc.).
#>

$resourceGroupName = "RGTest"

Remove-AzResourceGroup -Name $resourceGroupName -Force
