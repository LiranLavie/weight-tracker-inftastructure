variable "resource_group_name" {
  default     = "weight-tracker-resource-group"
  type        = string
  description = "name of the resource group."
}

variable "resource_group_location" {
  default     = "eastus"
  type        = string
  description = "Location of the resource group."
}

variable "server_count" {
  default     = 1
  type        = number
  description = "How many Servers to create."
}

variable "webserver_username" {
  description = "Admin username set in variables.tfvars for security reasons."
}
variable "webserver_password" {
  description = "Admin password set in variables.tfvars for security reasons."
}

variable "postgres_username" {
  description = "postgres username set in variables.tfvars for security reasons."
}
variable "postgres_password" {
  description = "postgres password set in variables.tfvars for security reasons."
}
variable "my_ip" {
  type        = string
  description = "my ip address to allow for ssh firewall rule,set in variables.tfvars for security reasons."
}
variable "vnet_address_space" {
  description = "Address space for a vnet"
}

variable "private_subnet_prefix" {
  description = "Set a prefix for private subnet"
}
variable "public_subnet_prefix" {
  description = "Set a prefix for public subnet"
}

variable "postgres_firewall_rule_start_ip" {
  description = "The start ip address when allowing access to postgres through postgres firewall"
}

variable "postgres_firewall_rule_end_ip" {
  description = "The end ip address when allowing access to postgres through postgres firewall"
}

##Used when storing state remotely
#variable "storage_account_key" {
#  type        = string
#  description = "key is stored in variables.tfvars for security reasons."
#}