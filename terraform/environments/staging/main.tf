# Staging Environment Configuration
# This file will contain Terraform configuration for the staging environment


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

resource "azurerm_resource_group" "staging_rg" {
  name     = var.resource_group_name
  location = var.location
}

module "aks" {
  source = "../../modules/aks"

  cluster_name        = var.aks_cluster_name
  dns_prefix          = var.aks_dns_prefix
  resource_group_name = azurerm_resource_group.staging_rg.name
  location            = azurerm_resource_group.staging_rg.location
  node_count          = var.aks_node_count
  vm_size             = var.aks_vm_size
  kubernetes_version  = var.kubernetes_version
  tags                = var.tags
}

output "resource_group_name" {
  value       = azurerm_resource_group.staging_rg.name
  description = "Staging resource group name."
}

output "aks_cluster_name" {
  value       = module.aks.cluster_name
  description = "Staging AKS cluster name."
}

output "aks_cluster_id" {
  value       = module.aks.cluster_id
  description = "Staging AKS cluster id."
}

