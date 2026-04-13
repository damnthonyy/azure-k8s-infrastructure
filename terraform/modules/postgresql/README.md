# PostgreSQL Terraform Module

Terraform module for provisioning Azure Database for PostgreSQL Flexible Server.

## Usage

```hcl
module "postgresql" {
  source = "../../modules/postgresql"

  # Example inputs (to be refined in later issues)
  # resource_group_name = azurerm_resource_group.main.name
  # location            = var.location
  # administrator_login = var.postgresql_admin_login
}
```

## Inputs

Inputs will be defined in `variables.tf` as the database implementation is added (see issue #11).

## Outputs

Outputs will be defined in `outputs.tf` to expose connection details to applications.
