#Set provider
terraform {
  required_version = ">=0.12"
  required_providers {
     azurerm = {
       source = "hashicorp/azurerm"
       version = "~>2.0"
     }
   }
##    Uncommant to save state in azure storage account
#    backend "azurerm" {
#    resource_group_name  = "weight-tracker-resource-group"
#    storage_account_name = "tfstat001"
#    container_name       = "tfstate"
#    key                  = "terraform.tfstate"
##    key deleted for safety
##    access_key           = ""

 # }
 }
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}