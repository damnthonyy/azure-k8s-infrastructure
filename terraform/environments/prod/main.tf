# Production Environment Configuration
# This file will contain Terraform configuration for the production environment


terraform {
  required_version = ">= 1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "prod_rg" {
  name     = "rg-azk8s-prod"
  location = "francecentral"
}

