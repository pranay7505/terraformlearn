terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.93.0"
    }
  }
}



resource "azurerm_resource_group" "app_resource" {
  name     = "app-resource"
  location = "West Europe"
}



resource "azurerm_virtual_network" "app_network" {
  name                = "example-network"
  location            = azurerm_resource_group.app_resource.location
  resource_group_name = azurerm_resource_group.app_resource.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name             = "SubnetA"
    address_prefixes = "10.0.1.0/24"

  }

}

resource "azurerm_subnet" "app_subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.app_resource.name
  virtual_network_name = azurerm_virtual_network.app_network.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "app_interface" {
  name                = "example-nic"
  location            = azurerm_resource_group.app_resource.location
  resource_group_name = azurerm_resource_group.app_resource.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.app_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.app_public.id
  }
  depends_on = [ azurerm_subnet.app_subnet ]
}

resource "azurerm_windows_virtual_machine" "app_machine" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.app_resource.name
  location            = azurerm_resource_group.app_resource.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.app_interface.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
resource "azurerm_public_ip" "app_public" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = azurerm_resource_group.app_resource.name
  location            = azurerm_resource_group.app_resource.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}