# Azure Storage Terraform Module

Terraform module for provisioning Azure Storage Accounts with encryption, private endpoints, and lifecycle policies.

## Usage

```hcl
module "storage" {
  source = "../../modules/storage"

  # Example inputs (to be refined in later issues)
  # resource_group_name     = azurerm_resource_group.main.name
  # location                = var.location
  # storage_account_name    = var.storage_account_name
}
```

## Inputs

Inputs will be defined in `variables.tf` as the Storage implementation is added (see issue #15).

## Outputs

Outputs will be defined in `outputs.tf` to expose storage endpoints and IDs to other modules.
