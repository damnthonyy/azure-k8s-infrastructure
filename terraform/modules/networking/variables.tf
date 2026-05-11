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
    delegated_service = optional(string)
    delegation_actions = optional(list(string), [
      "Microsoft.Network/virtualNetworks/subnets/join/action",
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
  default     = {}
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

variable "enable_azure_firewall" {
  type        = bool
  description = "Enable Azure Firewall deployment in this virtual network."
  default     = false
}

variable "azure_firewall_name" {
  type        = string
  description = "Azure Firewall name. If null, uses <vnet_name>-afw."
  default     = null
}

variable "azure_firewall_sku_tier" {
  type        = string
  description = "Azure Firewall SKU tier."
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Premium"], var.azure_firewall_sku_tier)
    error_message = "azure_firewall_sku_tier must be Standard or Premium."
  }
}

variable "azure_firewall_subnet_name" {
  type        = string
  description = "Subnet name reserved for Azure Firewall."
  default     = "AzureFirewallSubnet"
}

variable "azure_firewall_subnet_address_prefixes" {
  type        = list(string)
  description = "Address prefixes for the Azure Firewall subnet."
  default     = ["10.20.254.0/26"]
}

variable "azure_firewall_public_ip_name" {
  type        = string
  description = "Public IP name for Azure Firewall. If null, uses <vnet_name>-afw-pip."
  default     = null
}

variable "azure_firewall_threat_intel_mode" {
  type        = string
  description = "Threat intelligence mode for Azure Firewall."
  default     = "Alert"

  validation {
    condition     = contains(["Off", "Alert", "Deny"], var.azure_firewall_threat_intel_mode)
    error_message = "azure_firewall_threat_intel_mode must be Off, Alert, or Deny."
  }
}

variable "route_all_egress_through_firewall" {
  type        = bool
  description = "When true and firewall is enabled, creates default routes (0.0.0.0/0) on workload subnets to the firewall."
  default     = false
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Enable NAT Gateway for outbound egress from workload subnets."
  default     = false
}

variable "nat_gateway_name" {
  type        = string
  description = "NAT Gateway name. If null, uses <vnet_name>-natgw."
  default     = null
}

variable "nat_gateway_public_ip_name" {
  type        = string
  description = "Public IP name for NAT Gateway. If null, uses <vnet_name>-natgw-pip."
  default     = null
}

variable "nat_gateway_idle_timeout" {
  type        = number
  description = "Idle timeout in minutes for the NAT Gateway."
  default     = 4
}

variable "tags" {
  type        = map(string)
  description = "Tags for Azure networking resources."
  default     = {}
}
