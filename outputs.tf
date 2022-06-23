output "vms_password" {
  value       = module.servers_cluster
  sensitive   = true
  description = "Use command - (terraform output  -json) to retrieve VMs password."
}



