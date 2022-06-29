# Create inventory file for ansible using a template file
resource "local_file" "ansible_inventory" {
 content = templatefile("./templates/ansible-inventory-template.tmpl",
   {
     group_name      = "webserver_${terraform.workspace}"
     webserver_names = module.servers_cluster.webserver_names
     public_ip       = azurerm_public_ip.web_srv_lb_ip.ip_address
   })

  filename = pathexpand("~/weight-tracker-ansible/inventory/${terraform.workspace}/host")
}

# Create ansible host variables files for ansible using a template file
resource "local_file" "ansible_host_vars" {
  count = var.server_count
  content = templatefile("./templates/ansible-host-var-template.tmpl",
   {
     ansible_port    = module.server_load_balancer.nat_ssh_ports[count.index]
     ansible_user    = module.servers_cluster.admin_usernames[count.index]
     private_ip      = module.servers_cluster.webserver_private_ips[count.index]
     server_password = module.servers_cluster.admin_passwords[count.index]
   })

  filename = pathexpand("~/weight-tracker-ansible/inventory/${terraform.workspace}/host_vars/${module.servers_cluster.webserver_names[count.index]}.yml")
}

# Create env file only containing postgres info to use with ansible
resource "local_file" "ansible_env_template" {
  content = templatefile("./templates/ansible-webservers-vars-template.tmpl",
   {
      db_address     = "${module.postgres_server.postgres_db_name}.postgres.database.azure.com"
      db_name        = var.db_name
      db_user        = var.postgres_username
      db_pass        = var.postgres_password
      okta_url       = var.okta_url
      okta_client_id = var.okta_client_id
      okta_secret    = var.okta_secret
   })

  filename = pathexpand("~/weight-tracker-ansible/inventory/webservers_vars/webservers_vars.yml")
}