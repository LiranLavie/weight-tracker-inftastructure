#output "vm_password" {
#  value       = azurerm_linux_virtual_machine.web-server-vm[*].admin_password
#  description = "output user password to user from main."
#  sensitive = true
#}
output "web_server_nic_id" {
  value       = azurerm_network_interface.web_server_nic[*].id
  description = "output web server nic to user in load balabcer modules"
}

output "web_server_nic_ipconf_name" {
  value       = azurerm_network_interface.web_server_nic[*].ip_configuration[0].name
  description = "output web server nic to user in load balabcer modules"
}

output "admin_usernames" {
  value       = azurerm_linux_virtual_machine.web-server-vm[*].admin_username
  description = "output all admin usernames for ansible inventory template"
}

output "webserver_names" {
  value       = azurerm_linux_virtual_machine.web-server-vm[*].name
  description = "output all admin usernames for ansible inventory template"
}

output "admin_passwords" {
  value       = azurerm_linux_virtual_machine.web-server-vm[*].admin_password
  description = "output all admin usernames for ansible inventory template"
}

output "webserver_private_ips" {
  value       = azurerm_network_interface.web_server_nic[*].private_ip_address
  description = "output all admin usernames for ansible inventory template"
}