# PostgreSQL Terraform Module

Terraform module for provisioning Azure Database for PostgreSQL Flexible Server.

## Usage

```hcl
module "postgresql" {
  source = "../../modules/postgresql"

  server_name         = "pg-dev-azk8s-01"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  administrator_login = "postgresadmin"
  # administrator_password = var.postgresql_admin_password

  database_name         = "appdb"
  sku_name              = "B_Standard_B1ms"
  backup_retention_days = 7
  zone                  = "1"

  firewall_rules = {
    allow_azure_services = {
      start_ip_address = "0.0.0.0"
      end_ip_address   = "0.0.0.0"
    }
  }
}
```

If `administrator_password` is not provided, the module generates a strong random password.

## Inputs

- `server_name` - PostgreSQL server name.
- `resource_group_name` - Resource group where the server is created.
- `location` - Azure region.
- `postgresql_version` - PostgreSQL version, default: `13`.
- `administrator_login` - PostgreSQL administrator username.
- `administrator_password` - Optional administrator password, default: `null` (generated).
- `database_name` - Initial database name, default: `appdb`.
- `sku_name` - SKU tier and size.
- `storage_mb` - Storage in MB, default: `32768`.
- `backup_retention_days` - Backup retention window, default: `7`.
- `geo_redundant_backup_enabled` - Geo-redundant backups, default: `false`.
- `firewall_rules` - Firewall rules map, default: `{}`.
- `zone` - Primary availability zone, default: `null`.
- `high_availability_mode` - `SameZone` or `ZoneRedundant`, default: `null`.
- `standby_availability_zone` - Standby zone for HA, default: `null`.
- `delegated_subnet_id` - Subnet for private networking, default: `null`.
- `private_dns_zone_id` - Private DNS zone for private networking, default: `null`.
- `tags` - Resource tags, default: `{}`.

## Outputs

- `server_id` - PostgreSQL server resource ID.
- `server_name` - PostgreSQL server name.
- `server_fqdn` - PostgreSQL server FQDN.
- `database_name` - Default database name.
- `administrator_login` - PostgreSQL admin username.
- `administrator_password` - Effective admin password (sensitive).
- `connection_string` - PostgreSQL connection string (sensitive).
