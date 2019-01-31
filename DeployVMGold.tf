# Create Network Security Group and rule
resource "azurerm_network_security_group" "newNGS" {
    name                = "${var.VM_NAME}-nsg"
    location            = "${var.location}"
    resource_group_name = "${var.resource_group}"

    security_rule {
        name                       = "RDP"
        priority                   = 1000
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "3389"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    }

# Create network interface
data "azurerm_subnet" "existedsubnet" {
  name                 = "${var.subnet}"
  resource_group_name  = "${var.resource_group}"
  virtual_network_name = "${var.VNET}"
  }
  output "subnet_id" {
  value = "${data.azurerm_subnet.existedsubnet.id}"
}

resource "azurerm_network_interface" "NewNIC" {
    name                 = "${var.VM_NAME}-nic"
    location             = "${var.location}"
    resource_group_name  = "${var.resource_group}"
    network_security_group_id = "${azurerm_network_security_group.newNGS.id}"

    ip_configuration {
        name                      = "${var.VM_NAME}-nicConfiguration"
        subnet_id                  = "${data.azurerm_subnet.existedsubnet.id}"
        private_ip_address_allocation = "dynamic"
        
    }
}
# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group_name   = "${var.resource_group}"
    }

    byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "BootDiag_StorageAccount" {
    name                  = "diag${random_id.randomId.hex}"
    resource_group_name   = "${var.resource_group}"
    location              = "${var.location}"
    account_tier                = "Standard"
    account_replication_type    = "LRS"
}
  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  # Create virtual machine
resource "azurerm_virtual_machine" "newvirtualmachine" {
    name                  = "${var.VM_NAME}"
    location              = "${var.location}"
    resource_group_name   = "${var.resource_group}"
    network_interface_ids = ["${azurerm_network_interface.NewNIC.id}"]
    vm_size               = "Standard_B2s"
     
    storage_os_disk {
        name              = "${var.VM_NAME}-OsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
     publisher = "${var.vm_image_publisher}"
     offer = "${var.vm_image_offer}"
     sku = "${var.vm_image_sku}"
     version = "${var.vm_image_version}"
    }

    os_profile {
        computer_name  = "${var.VM_NAME}"
        admin_username = "${var.ADMIN_NAME}"
        admin_password = "${var.VM_PASSWORD}"
    }

    os_profile_windows_config {
        provision_vm_agent = "true"
     enable_automatic_upgrades = "true"
     winrm {
     protocol = "http"
     certificate_url =""
        }
    }





}