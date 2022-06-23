#Create a storage account to store state
#resource "azurerm_storage_account" "webserver_storage_account" {
#  name                     = "tfstat001"
#  resource_group_name      = azurerm_resource_group.rg.name
#  location                 = azurerm_resource_group.rg.location
#  account_tier             = "Standard"
#  account_replication_type = "LRS"
#}
#
##Add a storage container for storing state
#resource "azurerm_storage_container" "tfstate" {
#  name                  = "tfstate"
#  storage_account_name  = azurerm_storage_account.webserver_storage_account.name
#  container_access_type = "blob"
#}
