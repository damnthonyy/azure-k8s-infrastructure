# Azure Key Vault Terraform Module

Terraform module for provisioning Azure Key Vault with RBAC, soft-delete, and network restrictions.

## Usage

```hcl
module "keyvault" {
  source = "../../modules/keyvault"

  # Example inputs (to be refined in later issues)
  # resource_group_name = azurerm_resource_group.main.name
  # location            = var.location
  # key_vault_name      = var.key_vault_name
}
```

## Inputs

Inputs will be defined in `variables.tf` as the Key Vault implementation is added (see issue #13).

## Outputs

Outputs will be defined in `outputs.tf` to expose vault URIs and IDs to other components.
