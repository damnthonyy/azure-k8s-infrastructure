# Networking Terraform Module

Terraform module for provisioning Azure networking resources for the platform base layer:

- Virtual Network
- Subnets (AKS, App Gateway, PostgreSQL, ELK)
- Network Security Groups and rules
- Route tables and optional custom routes
- Optional Azure Firewall (disabled by default)
- Service endpoints on subnets

## CIDR Plan (default)

| Component | CIDR |
| --- | --- |
| VNet | `10.20.0.0/16` |
| AKS subnet | `10.20.1.0/24` |
| App Gateway subnet | `10.20.2.0/24` |
| PostgreSQL subnet | `10.20.3.0/24` |
| ELK subnet | `10.20.4.0/24` |

## Usage

```hcl
module "networking" {
  source = "../../modules/networking"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  vnet_name           = "vnet-azk8s-shared"

  tags = {
    environment = "dev"
    project     = "azure-k8s-infrastructure"
    managed_by  = "terraform"
  }
}
```

## Inputs

Key variables:

- `resource_group_name` - Target resource group.
- `location` - Azure region.
- `vnet_name` - Virtual network name.
- `vnet_address_space` - VNet CIDR list.
- `subnets` - Subnet definitions (CIDR + service endpoints).
- `subnets[*].delegated_service` - Optional subnet delegation target (for example PostgreSQL flexible server).
- `nsg_rules` - NSG rules by subnet.
- `route_table_routes` - Optional custom routes by subnet.
- `enable_azure_firewall` - Deploy Azure Firewall resources, default: `false`.
- `azure_firewall_subnet_name` - Dedicated firewall subnet name, default: `AzureFirewallSubnet`.
- `azure_firewall_subnet_address_prefixes` - Firewall subnet CIDR.
- `route_all_egress_through_firewall` - Add `0.0.0.0/0` routes from workload subnets to firewall, default: `false`.
- `tags` - Tags for all networking resources.

## Outputs

- `vnet_id` / `vnet_name`
- `subnet_ids`
- `subnet_address_prefixes`
- `network_security_group_ids`
- `route_table_ids`
- `azure_firewall_id`
- `azure_firewall_private_ip`
- `azure_firewall_public_ip`
