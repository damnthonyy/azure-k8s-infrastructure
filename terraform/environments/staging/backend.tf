terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state"
    storage_account_name = "azkstfstate001"
    container_name       = "tfstate"
    key                  = "staging/terraform.tfstate"
    use_azuread_auth     = true
  }
}
