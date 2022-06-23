#Module for creating webserver VMs


# Create network interface
resource "azurerm_network_interface" "web_server_nic" {
  count = var.vm_count
  name                = "web-server${count.index+1}-network-interface-${terraform.workspace}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "web-server${count.index+1}-nic-conf-${terraform.workspace}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create availability set
resource "azurerm_availability_set" "web_server_avset" {
   name                         = var.availability_set_name
   location                     = var.resource_group_location
   resource_group_name          = var.resource_group_name
   platform_fault_domain_count  = var.vm_count
   platform_update_domain_count = var.vm_count
   managed                      = true
 }

# Create virtual machines
resource "azurerm_linux_virtual_machine" "web-server-vm" {
  count = var.vm_count
  name                = "${var.server_name}-${count.index+1}-${terraform.workspace}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  size                = "Standard_B1s"
  #size                = "Standard_B2s"
  availability_set_id = azurerm_availability_set.web_server_avset.id
  admin_username      = var.username
  admin_password      = var.password
  network_interface_ids = [azurerm_network_interface.web_server_nic[count.index].id]
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}



