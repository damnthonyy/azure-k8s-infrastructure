variable "resource_group_name" {
  type        = string
  description = "Resource group where networking resources are created."
}

variable "location" {
  type        = string
  description = "Azure region where networking resources are created."
}

variable "vnet_name" {
  type        = string
  description = "Virtual network name."
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Address spaces for the virtual network."
  default     = ["10.20.0.0/16"]
}

variable "dns_servers" {
  type        = list(string)
  description = "Optional custom DNS servers for the virtual network."
  default     = []
}

variable "subnets" {
  type = map(object({
    address_prefixes = list(string)
    service_endpoints = optional(list(string), [
      "Microsoft.Storage",
      "Microsoft.KeyVault",
    ])
  }))
  description = "Subnet definitions keyed by subnet name."
  default = {
    aks = {
      address_prefixes = ["10.20.1.0/24"]
    }
    appgw = {
      address_prefixes = ["10.20.2.0/24"]
    }
    postgresql = {
      address_prefixes = ["10.20.3.0/24"]
    }
    elk = {
      address_prefixes = ["10.20.4.0/24"]
    }
  }
}

variable "nsg_rules" {
  type = map(list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_ranges    = list(string)
    source_address_prefix      = string
    destination_address_prefix = string
  })))
  description = "NSG rules keyed by subnet name."
  default = {
    aks = [
      {
        name                       = "allow-k8s-api-internal"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_ranges    = ["443"]
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "VirtualNetwork"
      }
    ]
    appgw = [
      {
        name                       = "allow-http-https"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_ranges    = ["80", "443"]
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
    postgresql = [
      {
        name                       = "allow-postgres-from-vnet"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_ranges    = ["5432"]
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "VirtualNetwork"
      }
    ]
    elk = [
      {
        name                       = "allow-elk-from-vnet"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_ranges    = ["5601", "9200", "9300"]
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "VirtualNetwork"
      }
    ]
  }
}

variable "route_table_routes" {
  type = map(list(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  })))
  description = "Custom route definitions keyed by subnet name."
  default     = {}
}

variable "disable_bgp_route_propagation" {
  type        = bool
  description = "Disable BGP route propagation on route tables."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags for Azure networking resources."
  default     = {}
}
