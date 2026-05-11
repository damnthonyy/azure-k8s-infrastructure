output "app_gateway_id" {
  value       = azurerm_application_gateway.this.id
  description = "Application Gateway resource ID."
}

output "app_gateway_name" {
  value       = azurerm_application_gateway.this.name
  description = "Application Gateway name."
}

output "public_ip" {
  value       = azurerm_public_ip.appgw.ip_address
  description = "Application Gateway public IP address."
}

output "backend_pool_id" {
  value       = "${azurerm_application_gateway.this.id}/backendAddressPools/${var.backend_pool_name}"
  description = "Backend address pool ID (for AKS ingress controller)."
}
