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
  default     = 3
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

variable "storage_account_key" {
  type        = string
  description = "key is stored in variables.tfvars for security reasons."
}