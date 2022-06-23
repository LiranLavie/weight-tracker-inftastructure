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
  description = "How many Vms to add."
}

variable "lb_public_ip_id" {
  type        = string
  description = "Load balancer public ip id."
}

variable "web_server_nic_id" {
  description = "Web server nic id."
}

variable "web_server_nic_ip_conf_name" {
  description = "Wen server nic IP configuration"
}