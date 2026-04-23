resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.vnet_address_space
  dns_servers         = var.dns_servers
  tags                = var.tags
}

resource "azurerm_network_security_group" "subnet" {
  for_each = var.subnets

  name                = "${var.vnet_name}-${each.key}-nsg"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

locals {
  nsg_rule_maps = [
    for subnet_name, rules in var.nsg_rules : {
      for rule in rules : "${subnet_name}.${rule.name}" => merge(rule, {
        subnet_name = subnet_name
      }) if contains(keys(var.subnets), subnet_name)
    }
  ]

  route_maps = [
    for subnet_name, routes in var.route_table_routes : {
      for route in routes : "${subnet_name}.${route.name}" => merge(route, {
        subnet_name = subnet_name
      }) if contains(keys(var.subnets), subnet_name)
    }
  ]

  nsg_rules_flat    = length(local.nsg_rule_maps) > 0 ? merge(local.nsg_rule_maps...) : {}
  route_tables_flat = length(local.route_maps) > 0 ? merge(local.route_maps...) : {}
}

resource "azurerm_network_security_rule" "subnet_rule" {
  for_each = local.nsg_rules_flat

  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_ranges     = each.value.destination_port_ranges
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.subnet[each.value.subnet_name].name
}

resource "azurerm_subnet" "this" {
  for_each = var.subnets

  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = each.value.service_endpoints
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = var.subnets

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = azurerm_network_security_group.subnet[each.key].id
}

resource "azurerm_route_table" "subnet" {
  for_each = var.subnets

  name                          = "${var.vnet_name}-${each.key}-rt"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  bgp_route_propagation_enabled = !var.disable_bgp_route_propagation
  tags                          = var.tags
}

resource "azurerm_route" "subnet_route" {
  for_each = local.route_tables_flat

  name                   = each.value.name
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.subnet[each.value.subnet_name].name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_type == "VirtualAppliance" ? each.value.next_hop_in_ip_address : null
}

resource "azurerm_subnet_route_table_association" "this" {
  for_each = var.subnets

  subnet_id      = azurerm_subnet.this[each.key].id
  route_table_id = azurerm_route_table.subnet[each.key].id
}
