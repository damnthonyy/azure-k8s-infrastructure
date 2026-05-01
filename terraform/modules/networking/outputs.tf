output "vnet_id" {
  value       = azurerm_virtual_network.this.id
  description = "ID of the virtual network."
}

output "vnet_name" {
  value       = azurerm_virtual_network.this.name
  description = "Name of the virtual network."
}

output "subnet_ids" {
  value       = { for name, subnet in azurerm_subnet.this : name => subnet.id }
  description = "Subnet IDs keyed by subnet name."
}

output "subnet_address_prefixes" {
  value       = { for name, subnet in azurerm_subnet.this : name => subnet.address_prefixes }
  description = "Subnet address prefixes keyed by subnet name."
}

output "network_security_group_ids" {
  value       = { for name, nsg in azurerm_network_security_group.subnet : name => nsg.id }
  description = "NSG IDs keyed by subnet name."
}

output "route_table_ids" {
  value       = { for name, rt in azurerm_route_table.subnet : name => rt.id }
  description = "Route table IDs keyed by subnet name."
}

output "azure_firewall_id" {
  value       = try(azurerm_firewall.this[0].id, null)
  description = "Azure Firewall ID when enabled, otherwise null."
}

output "azure_firewall_private_ip" {
  value       = try(azurerm_firewall.this[0].ip_configuration[0].private_ip_address, null)
  description = "Azure Firewall private IP when enabled, otherwise null."
}

output "azure_firewall_public_ip" {
  value       = try(azurerm_public_ip.firewall[0].ip_address, null)
  description = "Azure Firewall public IP when enabled, otherwise null."
}
