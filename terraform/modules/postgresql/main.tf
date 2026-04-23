resource "random_password" "administrator" {
  count = var.administrator_password == null ? 1 : 0

  length           = 32
  special          = true
  override_special = "!@#$%&*()-_=+[]{}<>:?"
}

locals {
  effective_administrator_password = coalesce(var.administrator_password, random_password.administrator[0].result)
}

resource "azurerm_postgresql_flexible_server" "this" {
  name                = var.server_name
  resource_group_name = var.resource_group_name
  location            = var.location

  version                = var.postgresql_version
  administrator_login    = var.administrator_login
  administrator_password = local.effective_administrator_password
  sku_name               = var.sku_name
  storage_mb             = var.storage_mb

  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled

  zone                = var.zone
  delegated_subnet_id = var.delegated_subnet_id
  private_dns_zone_id = var.private_dns_zone_id

  dynamic "high_availability" {
    for_each = var.high_availability_mode == null ? [] : [var.high_availability_mode]
    content {
      mode                      = high_availability.value
      standby_availability_zone = var.standby_availability_zone
    }
  }

  tags = var.tags
}

resource "azurerm_postgresql_flexible_server_database" "this" {
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.this.id
  charset   = var.database_charset
  collation = var.database_collation
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "this" {
  for_each = var.delegated_subnet_id == null ? var.firewall_rules : {}

  name             = each.key
  server_id        = azurerm_postgresql_flexible_server.this.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}
