output "server_id" {
  value       = azurerm_postgresql_flexible_server.this.id
  description = "ID of the PostgreSQL flexible server."
}

output "server_name" {
  value       = azurerm_postgresql_flexible_server.this.name
  description = "Name of the PostgreSQL flexible server."
}

output "server_fqdn" {
  value       = azurerm_postgresql_flexible_server.this.fqdn
  description = "FQDN of the PostgreSQL flexible server."
}

output "database_name" {
  value       = azurerm_postgresql_flexible_server_database.this.name
  description = "Name of the default PostgreSQL database."
}

output "administrator_login" {
  value       = azurerm_postgresql_flexible_server.this.administrator_login
  description = "Administrator login username."
}

output "administrator_password" {
  value       = local.effective_administrator_password
  description = "Administrator password used by PostgreSQL."
  sensitive   = true
}

output "connection_string" {
  value       = format("postgresql://%s:%s@%s:5432/%s?sslmode=require", azurerm_postgresql_flexible_server.this.administrator_login, local.effective_administrator_password, azurerm_postgresql_flexible_server.this.fqdn, azurerm_postgresql_flexible_server_database.this.name)
  description = "Connection string for the default PostgreSQL database."
  sensitive   = true
}
