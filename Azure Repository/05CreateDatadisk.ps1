$ResourceGroupName = "RGTest"
$vmName            = "TestVM01"

$vm = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $vmName

$vm=Add-AzVMDataDisk -VM $vm `
-Name "Datadisktest01" `
-DiskSizeInGB 256 `
-Lun 0 `
-CreateOption Empty `
-StorageAccountType Standard_LRS `
-Caching ReadWrite

Update-AzVM -ResourceGroupName $ResourceGroupName $vm
