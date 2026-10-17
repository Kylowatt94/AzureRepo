<#
.SYNOPSIS
    Attaches a new, empty 256 GB managed data disk to the lab VM.

.NOTES
    Requires:   Az.Compute
    Depends on: 03-New-WindowsVM.ps1

    The disk still needs to be initialized and formatted inside the guest OS
    (Disk Management or Initialize-Disk) before it is usable.
#>

$ResourceGroupName = "RGTest"
$vmName            = "TestVM01"

$vm = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $vmName

$vm = Add-AzVMDataDisk -VM $vm `
    -Name "Datadisktest01" `
    -DiskSizeInGB 256 `
    -Lun 0 `
    -CreateOption Empty `
    -StorageAccountType Standard_LRS `
    -Caching ReadWrite

Update-AzVM -ResourceGroupName $ResourceGroupName -VM $vm
