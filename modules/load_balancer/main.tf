# Create webserver load balancer
resource "azurerm_lb" "web_server_lb" {
   name                = "web-server-lb-${terraform.workspace}"
   location            = var.resource_group_location
   resource_group_name = var.resource_group_name
   sku                 = "Standard"

   frontend_ip_configuration {
     name                 = "lb-public-ip-conf-${terraform.workspace}"
     public_ip_address_id = var.lb_public_ip_id
   }
 }

# Create webserver load balancer address pool
resource "azurerm_lb_backend_address_pool" "webserver_lb_pool" {
   loadbalancer_id     = azurerm_lb.web_server_lb.id
   name                = "webserver-lb-pool-${terraform.workspace}"
 }

# Add load balancer rule
 resource "azurerm_lb_rule" "web_srv_lb_rule_8080" {
   resource_group_name            = var.resource_group_name
   backend_port                   = 8080
   frontend_ip_configuration_name = azurerm_lb.web_server_lb.frontend_ip_configuration[0].name
   frontend_port                  = 8080
   loadbalancer_id                = azurerm_lb.web_server_lb.id
   name                           = "Port_8080"
   protocol                       = "Tcp"
   backend_address_pool_ids = [azurerm_lb_backend_address_pool.webserver_lb_pool.id]
   disable_outbound_snat = true
 }


resource "azurerm_lb_nat_rule" "web_srv_lb_nat_roles" {
  count                          = var.vm_count
  backend_port                   = 22
  frontend_ip_configuration_name = azurerm_lb.web_server_lb.frontend_ip_configuration[0].name
  frontend_port                  = "22${count.index+1}"
  loadbalancer_id                = azurerm_lb.web_server_lb.id
  name                           = "Port_22_to_Port_22${count.index+1}"
  protocol                       = "Tcp"
  resource_group_name            = var.resource_group_name
}

resource "azurerm_network_interface_backend_address_pool_association" "network_pool_association" {
  count                   = var.vm_count
  backend_address_pool_id = azurerm_lb_backend_address_pool.webserver_lb_pool.id
  ip_configuration_name   = "web-server${count.index+1}-nic-conf-${terraform.workspace}"
  network_interface_id    = var.web_server_nic_id[count.index]
}

resource "azurerm_network_interface_nat_rule_association" "nat_rule_association" {
  count                 = var.vm_count
  ip_configuration_name = var.web_server_nic_ip_conf_name[count.index]
  nat_rule_id           = azurerm_lb_nat_rule.web_srv_lb_nat_roles[count.index].id
  network_interface_id  = var.web_server_nic_id[count.index]
}

# Create webserver load balancer probe
resource "azurerm_lb_probe" "lb_probe" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id = azurerm_lb.web_server_lb.id
  name            = "web-server-lb-probe-${terraform.workspace}"
  port            = 8080
  protocol        = "HTTP"
  request_path    = "/"
}