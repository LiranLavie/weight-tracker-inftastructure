# Create resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}-${terraform.workspace}"
  location = var.resource_group_location
}

# Create virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  address_space       = [var.vnet_address_space]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create public subnet
resource "azurerm_subnet" "public_subnet" {
  name                 = "public-subnet-${terraform.workspace}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.public_subnet_prefix]
}

# Create private subnet
resource "azurerm_subnet" "private_subnet" {
  name                 = "private-subnet-${terraform.workspace}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.private_subnet_prefix]
  delegation{
     name = "postgreSQL-delegate"
     service_delegation {name = "Microsoft.DBforPostgreSQL/flexibleServers"}
  }
}

# Init web servers with module
module "servers_cluster" {
  source                  = "./modules/web_server"
  vm_count                = var.server_count
  availability_set_name   = "web_server_avset-${terraform.workspace}"
  resource_group_location = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  server_name             = "web-server"
  subnet_id               = azurerm_subnet.public_subnet.id
  username                = var.webserver_username
  password                = var.webserver_password

  depends_on = [azurerm_resource_group.rg,azurerm_subnet.public_subnet,azurerm_public_ip.web_srv_lb_ip]
}

#Init load balancer module
module "server_load_balancer" {
  source         = "./modules/load_balancer"
  vm_count = var.server_count
  lb_public_ip_id = azurerm_public_ip.web_srv_lb_ip.id
  resource_group_location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  web_server_nic_id = module.servers_cluster.web_server_nic_id
  web_server_nic_ip_conf_name = module.servers_cluster.web_server_nic_ipconf_name
  depends_on = [module.servers_cluster,azurerm_resource_group.rg,azurerm_public_ip.web_srv_lb_ip]
}

#Init postgres module
module "postgres_server" {
  source = "./modules/postgres_db"
  firewall_rule_end_ip = var.postgres_firewall_rule_end_ip
  firewall_rule_start_ip = var.postgres_firewall_rule_start_ip
  postgres_password = var.postgres_password
  postgres_username = var.postgres_username
  private_subnet_id = azurerm_subnet.private_subnet.id
  resource_group_location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  vnet_id = azurerm_virtual_network.vnet.id
}

 # Create public ip for load balancer
resource "azurerm_public_ip" "web_srv_lb_ip" {
   name                         = "lb-public-ip-${terraform.workspace}"
   location                     = azurerm_resource_group.rg.location
   resource_group_name          = azurerm_resource_group.rg.name
   allocation_method            = "Static"
   sku = "Standard"
 }

# Create public ip for NAT
resource "azurerm_public_ip" "nat_outbound_public_ip" {
  allocation_method   = "Static"
  location            = azurerm_resource_group.rg.location
  name                = "nat-outbound-public-ip-${terraform.workspace}"
  resource_group_name = azurerm_resource_group.rg.name
  sku = "Standard"
}

# Create NAT gateway
resource "azurerm_nat_gateway" "public_sub_nat_gateway" {
  location            = azurerm_resource_group.rg.location
  name                = "public-sub-nat-gateway-${terraform.workspace}"
  resource_group_name = azurerm_resource_group.rg.name

}

# Association NAT with subnet
resource "azurerm_subnet_nat_gateway_association" "sub_nat_association" {
  nat_gateway_id = azurerm_nat_gateway.public_sub_nat_gateway.id
  subnet_id      = azurerm_subnet.public_subnet.id
}

# Association NAT with public ip
resource "azurerm_nat_gateway_public_ip_association" "gateway_public_ip_association" {
  nat_gateway_id       = azurerm_nat_gateway.public_sub_nat_gateway.id
  public_ip_address_id = azurerm_public_ip.nat_outbound_public_ip.id
}

# Create Network Security Group and rules for public subnet
resource "azurerm_network_security_group" "public_subnet_ngs" {
  name                = "public-subnet-ngs-${terraform.workspace}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.my_ip
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Port_8080"
    priority                   = 1400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowVnetInBound"
    priority                   = 3000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "DenyAllInBound"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create Network Security Group and rules for private subnet
resource "azurerm_network_security_group" "private_subnet_ngs" {
  name                = "private-subnet-ngs-${terraform.workspace}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Port_5432"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = var.public_subnet_prefix
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DenyAllInBound"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Connect the security group to the public subnet
resource "azurerm_subnet_network_security_group_association" "public-subnet-nsg-association" {
  subnet_id                 = azurerm_subnet.public_subnet.id
  network_security_group_id = azurerm_network_security_group.public_subnet_ngs.id
}

# Connect the security group to the private subnet
resource "azurerm_subnet_network_security_group_association" "private-subnet-nsg-association" {
  subnet_id                 = azurerm_subnet.private_subnet.id
  network_security_group_id = azurerm_network_security_group.private_subnet_ngs.id
}








