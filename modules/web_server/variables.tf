variable "resource_group_location" {
  type        = string
  description = "Location of the resource group."
}

variable "resource_group_name" {
  type        = string
  description = "Name of resource group."
}

variable "vm_count" {
  default     = 1
  type        = number
  description = "How many Vms to create."
}

variable "subnet_id" {
  type        = string
  description = "Network subnet id."
}

variable "availability_set_name" {
  type        = string
  description = "Name of vailability set."
}

variable "server_name" {
  type        = string
  description = "Name of server."
}

variable "username" {
  type        = string
  description = "Admin username."
}
variable "password" {
  type        = string
  description = "Admin password."
}







