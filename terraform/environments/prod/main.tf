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
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_log_analytics_workspace" "aks" {
  name                = "${var.resource_group_name}-law"
  location            = azurerm_resource_group.prod_rg.location
  resource_group_name = azurerm_resource_group.prod_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

module "aks" {
  source = "../../modules/aks"

  cluster_name        = var.aks_cluster_name
  dns_prefix          = var.aks_dns_prefix
  resource_group_name = azurerm_resource_group.prod_rg.name
  location            = azurerm_resource_group.prod_rg.location

  node_count              = var.aks_node_count
  vm_size                 = var.aks_vm_size
  enable_autoscaling      = var.aks_enable_autoscaling
  min_node_count          = var.aks_min_node_count
  max_node_count          = var.aks_max_node_count
  default_node_pool_zones = var.aks_default_node_pool_zones

  user_node_pools            = var.aks_user_node_pools
  log_analytics_workspace_id = azurerm_log_analytics_workspace.aks.id

  kubernetes_version = var.kubernetes_version
  tags               = var.tags
}

module "postgresql" {
  source = "../../modules/postgresql"

  server_name                  = var.postgresql_server_name
  resource_group_name          = azurerm_resource_group.prod_rg.name
  location                     = azurerm_resource_group.prod_rg.location
  administrator_login          = var.postgresql_admin_login
  administrator_password       = var.postgresql_admin_password
  database_name                = var.postgresql_database_name
  sku_name                     = var.postgresql_sku_name
  storage_mb                   = var.postgresql_storage_mb
  backup_retention_days        = var.postgresql_backup_retention_days
  zone                         = var.postgresql_zone
  high_availability_mode       = var.postgresql_high_availability_mode
  standby_availability_zone    = var.postgresql_standby_availability_zone
  geo_redundant_backup_enabled = var.postgresql_geo_redundant_backup_enabled
  firewall_rules               = var.postgresql_firewall_rules
  tags                         = var.tags
}

output "resource_group_name" {
  value       = azurerm_resource_group.prod_rg.name
  description = "Production resource group name."
}

output "aks_cluster_name" {
  value       = module.aks.cluster_name
  description = "Production AKS cluster name."
}

output "aks_cluster_id" {
  value       = module.aks.cluster_id
  description = "Production AKS cluster id."
}

output "postgresql_server_id" {
  value       = module.postgresql.server_id
  description = "Production PostgreSQL flexible server id."
}

output "postgresql_server_fqdn" {
  value       = module.postgresql.server_fqdn
  description = "Production PostgreSQL flexible server FQDN."
}
