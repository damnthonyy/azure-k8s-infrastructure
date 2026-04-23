# AKS Terraform Module

Minimal Terraform module for provisioning an Azure Kubernetes Service (AKS) cluster for the `azure-k8s-infrastructure` project.

This module is intentionally small and environment-agnostic. It creates one AKS cluster with a single system node pool and expects the calling environment to provide the concrete values.

## What This Module Creates

- One `azurerm_kubernetes_cluster`
- One system default node pool
- A system-assigned managed identity
- Basic tags

## Usage

Call this module from an environment folder such as `terraform/environments/dev`, `staging`, or `prod`.

```hcl
module "aks" {
  source = "../../modules/aks"

  cluster_name        = var.aks_cluster_name
  dns_prefix          = var.aks_dns_prefix
  resource_group_name = azurerm_resource_group.dev_rg.name
  location            = azurerm_resource_group.dev_rg.location
  # Fixed-size cluster (default)
  node_count = var.aks_node_count
  vm_size    = var.aks_vm_size

  # Or enable autoscaling (example for prod)
  # enable_autoscaling = true
  # min_node_count     = 3
  # max_node_count     = 10

  kubernetes_version = var.kubernetes_version
  tags               = var.tags
}
```

## Inputs

The module accepts the following variables:

- `cluster_name` - AKS cluster name
- `dns_prefix` - DNS prefix for the cluster
- `resource_group_name` - Resource group name where AKS will be created
- `location` - Azure region
- `node_count` - Node count for the default node pool when autoscaling is disabled, default: `2`
- `enable_autoscaling` - Enable autoscaling on the system node pool, default: `false`
- `min_node_count` - Minimum number of nodes when autoscaling is enabled, default: `2`
- `max_node_count` - Maximum number of nodes when autoscaling is enabled, default: `10`
- `vm_size` - VM size for the default node pool, default: `Standard_D2s_v5`
- `log_analytics_workspace_id` - Log Analytics Workspace ID used to enable Azure Monitor integration for the cluster
- `default_node_pool_zones` - Availability zones for the system node pool, default: `[]`
- `user_node_pools` - Map of additional user node pools to create (key = node pool name) with `vm_size`, `node_count`, and optional `zones`
- `tags` - Tags to apply to the AKS resource, default: `{}`
- `kubernetes_version` - Optional AKS Kubernetes version, default: `null`

## Outputs

The module exposes:

- `cluster_name` - AKS cluster name
- `cluster_id` - AKS cluster resource ID

## Notes

- This module does not create a resource group.
- This module does not configure networking or ACR access.
- Environment-specific values should be defined in the calling environment, usually through `terraform.tfvars`.
