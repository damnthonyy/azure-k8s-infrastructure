# Networking Terraform Module

Terraform module for provisioning Azure networking resources such as virtual network, subnets, and NSGs.

## Usage

```hcl
module "networking" {
  source = "../../modules/networking"

  # Example inputs (to be refined in later issues)
  # resource_group_name = azurerm_resource_group.main.name
  # location            = var.location
  # vnet_cidr           = "10.0.0.0/16"
}
```

## Inputs

Inputs will be defined in `variables.tf` as the networking implementation is added (see issue #9).

## Outputs

Outputs will be defined in `outputs.tf` to expose subnet and NSG IDs for other modules (AKS, PostgreSQL, ELK, etc.).
