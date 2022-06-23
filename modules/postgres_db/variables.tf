variable "resource_group_location" {
  type        = string
  description = "Location of the resource group."
}

variable "resource_group_name" {
  type        = string
  description = "Name of resource group."
}

variable "vnet_id" {
  type        = string
  description = "Virtual network id."
}

variable "private_subnet_id" {
  type        = string
  description = "Virtual network id."
}

variable "postgres_username" {
  description = "postgres username set in variables.tfvars for security reasons."
}
variable "postgres_password" {
  description = "postgres password set in variables.tfvars for security reasons."
}

variable "firewall_rule_start_ip" {
  description = "Firewall rule to start from this ip."
}

variable "firewall_rule_end_ip" {
  description = "Firewall rule to end with this ip."
}