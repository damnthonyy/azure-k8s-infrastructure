resource "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name                = "system"
    vm_size             = var.vm_size
    enable_auto_scaling = var.enable_autoscaling
    zones               = length(var.default_node_pool_zones) > 0 ? var.default_node_pool_zones : null

    node_count = var.enable_autoscaling ? null : var.node_count
    min_count  = var.enable_autoscaling ? var.min_node_count : null
    max_count  = var.enable_autoscaling ? var.max_node_count : null
  }

  identity {
    type = "SystemAssigned"
  }

  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  role_based_access_control_enabled = true
  tags                              = var.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "user" {
  for_each = var.user_node_pools

  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size               = each.value.vm_size
  node_count            = each.value.node_count
  mode                  = "User"
  zones                 = length(each.value.zones) > 0 ? each.value.zones : null

  tags = var.tags
}
