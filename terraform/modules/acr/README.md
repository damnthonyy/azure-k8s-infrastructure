# Azure Container Registry Terraform Module

Terraform module for provisioning Azure Container Registry (ACR) with enterprise features.

## Usage

```hcl
module "acr" {
  source = "../../modules/acr"

  # Example inputs (to be refined in later issues)
  # resource_group_name = azurerm_resource_group.main.name
  # location            = var.location
  # registry_name       = var.acr_name
}
```

## Inputs

Inputs will be defined in `variables.tf` as the ACR implementation is added (see issue #12).

## Outputs

Outputs will be defined in `outputs.tf` to expose registry endpoints to CI/CD and AKS.
