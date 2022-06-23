# For creating ansible var files
output "nat_ssh_ports" {
  value       = azurerm_lb_nat_rule.web_srv_lb_nat_roles[*].frontend_port
  description = "output all nat rule ssh ports"
}