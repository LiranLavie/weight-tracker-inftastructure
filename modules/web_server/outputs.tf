output "vm_password" {
  value       = azurerm_linux_virtual_machine.web-server-vm[*].admin_password
  description = "output user password to user from main."
  sensitive = true
}
output "web_server_nic_id" {
  value       = azurerm_network_interface.web_server_nic[*].id
  description = "output web server nic to user in load balabcer modules"
}

output "web_server_nic_ipconf_name" {
  value       = azurerm_network_interface.web_server_nic[*].ip_configuration[0].name
  description = "output web server nic to user in load balabcer modules"
}