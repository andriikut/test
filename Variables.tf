# Define variables for VM deployment 
variable "VM_NAME" {
default = "goldVM"
}
variable "vm_image_offer" {
//Get-AzureRMVMImageOffer -Location 'northeurope' -Publisher 'MicrosoftWindowsServer' | Select Offer
description = "vm image vendor's VM offering"
default = "WindowsServer"
}
variable "vm_image_publisher" {
// Get-AzureRmVMImagePublisher -Location 'northeurope' | Select PublisherName
description = "vm image vendor"
default = "MicrosoftWindowsServer"
}
variable "vm_image_sku" {
default = "2016-Datacenter-smalldisk"
}
variable "vm_image_version" {
description = "vm image version"
default = "latest"
}
variable "resource_group" {
default = "E600036"
}
variable "location" {
default = "northeurope"
}
variable "VNET" {
default = "E600036"
}
variable "subnet" {
default = "TEST-subnet"
}
variable "ADMIN_NAME" {
default="GGADMIN" 
}
variable "VM_PASSWORD" {
default="Aspire430!" 
}