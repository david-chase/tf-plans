resource "azurerm_resource_group" "rg" {
  name     = "mobile_prod_rg"
  location = "canadacentral"
}

resource "azurerm_availability_set" "DemoAset" {
  name                = "mobile_prod_aset"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_virtual_network" "vnet" {
  name                = "mobile_prod_vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "mobile_prod_subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# -------------------------------------
# First VM
# -------------------------------------
resource "azurerm_network_interface" "example" {
  name                = "mobile_prod_nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "example" {
  name                = "st01-dev-imco-321"
  computer_name       = "st01devimco321"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_A4_v2"
  # size                = var.densify_recommendations.st01-dev-imco-321.recommendedType
  admin_username      = var.owner
  admin_password      = "Passw0rd!"
  availability_set_id = azurerm_availability_set.DemoAset.id
  network_interface_ids = [
    azurerm_network_interface.example.id,
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

  tags = {
    owner = var.owner
    purpose = "Terraform demo"
    createdate = formatdate( "YYYY-MMM-DD hh:mm", timestamp() )
  }
}

# -------------------------------------
# Second VM
# -------------------------------------
resource "azurerm_network_interface" "example1" {
    name                = "mobile_prod_nic1"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
  
    ip_configuration {
      name                          = "internal"
      subnet_id                     = azurerm_subnet.subnet.id
      private_ip_address_allocation = "Dynamic"
    }
  }

resource "azurerm_windows_virtual_machine" "example1" {
    name                = "st01-dev-kotl-413"
    computer_name       = "st01devkotl413"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    size                = "Standard_A4_v2"
    # size                = var.densify_recommendations.st01-dev-kotl-413.recommendedType
    admin_username      = var.owner
    admin_password      = "Passw0rd!"
    availability_set_id = azurerm_availability_set.DemoAset.id
    network_interface_ids = [
      azurerm_network_interface.example1.id,
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

    tags = {
      owner = var.owner
      purpose = "Terraform demo"
      createdate = formatdate( "YYYY-MMM-DD hh:mm", timestamp() )
    }
  }

# -------------------------------------
# Third VM
# -------------------------------------
resource "azurerm_network_interface" "example2" {
    name                = "mobile_prod_nic2"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_windows_virtual_machine" "example2" {
    name                = "st01-prepro-duct-323"
    computer_name       = "st01preprod323"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    size                = "standard_a2_v2"
    # size                = var.densify_recommendations.st01-prepro-duct-323.recommendedType
    admin_username      = var.owner
    admin_password      = "Passw0rd!"
    availability_set_id = azurerm_availability_set.DemoAset.id
    network_interface_ids = [
    azurerm_network_interface.example2.id,
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

    tags = {
      owner = var.owner
      purpose = "Terraform demo"
      createdate = formatdate( "YYYY-MMM-DD hh:mm", timestamp() )
    }
}