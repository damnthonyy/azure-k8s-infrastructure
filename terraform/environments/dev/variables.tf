variable "location" {
  type        = string
  description = "Azure region for the development environment."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name for development."
}

variable "networking_vnet_name" {
  type        = string
  description = "Virtual network name for development."
  default     = "vnet-dev-azk8s-01"
}

variable "networking_vnet_address_space" {
  type        = list(string)
  description = "Address space for the development virtual network."
  default     = ["10.20.0.0/16"]
}

variable "networking_subnets" {
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
  description = "Subnet CIDR plan for development."
  default = {
    aks = {
      address_prefixes = ["10.20.1.0/24"]
    }
    appgw = {
      address_prefixes = ["10.20.2.0/24"]
    }
    postgresql = {
      address_prefixes  = ["10.20.3.0/24"]
      delegated_service = "Microsoft.DBforPostgreSQL/flexibleServers"
    }
    elk = {
      address_prefixes = ["10.20.4.0/24"]
    }
  }
}

variable "networking_nsg_rules" {
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
  description = "NSG rules for development subnets."
  default = {
    aks = [
      {
        name                       = "allow-aks-control-plane"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_ranges    = ["443"]
        source_address_prefix      = "AzureCloud"
        destination_address_prefix = "VirtualNetwork"
      }
    ]
    appgw = [
      {
        name                       = "allow-http-https-inbound"
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
        name                       = "allow-postgresql-from-aks"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_ranges    = ["5432"]
        source_address_prefix      = "10.20.1.0/24"
        destination_address_prefix = "10.20.3.0/24"
      }
    ]
    elk = [
      {
        name                       = "allow-elk-from-aks"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_ranges    = ["5601", "9200", "9300"]
        source_address_prefix      = "10.20.1.0/24"
        destination_address_prefix = "10.20.4.0/24"
      }
    ]
  }
}

variable "networking_route_table_routes" {
  type = map(list(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  })))
  description = "Custom route table routes for development."
  default     = {}
}

variable "networking_enable_azure_firewall" {
  type        = bool
  description = "Enable Azure Firewall in the development network."
  default     = false
}

variable "networking_azure_firewall_name" {
  type        = string
  description = "Azure Firewall name for development."
  default     = "afw-dev-azk8s-01"
}

variable "networking_azure_firewall_subnet_address_prefixes" {
  type        = list(string)
  description = "Address prefixes for the Azure Firewall subnet in development."
  default     = ["10.20.254.0/26"]
}

variable "networking_route_all_egress_through_firewall" {
  type        = bool
  description = "Route all egress traffic through Azure Firewall in development."
  default     = false
}

variable "aks_cluster_name" {
  type        = string
  description = "AKS cluster name for development."
}

variable "aks_dns_prefix" {
  type        = string
  description = "AKS DNS prefix for development."
}

variable "aks_node_count" {
  type        = number
  description = "Node count for the AKS default node pool in development."
  default     = 2
}

variable "aks_vm_size" {
  type        = string
  description = "VM size for the AKS default node pool in development."
  default     = "Standard_D2s_v5"
}

variable "kubernetes_version" {
  type        = string
  description = "Optional Kubernetes version for AKS. Use null to let Azure pick a default supported version."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags for development resources."
  default     = {}
}

variable "aks_user_node_pools" {
  type = map(object({
    vm_size    = string
    node_count = number
    zones      = optional(list(string), [])
  }))
  description = "User node pools for the AKS cluster in development."
  default     = {}
}

variable "postgresql_server_name" {
  type        = string
  description = "PostgreSQL flexible server name for development."
  default     = "pg-dev-azk8s-01"
}

variable "postgresql_admin_login" {
  type        = string
  description = "Administrator login for development PostgreSQL."
  default     = "postgresadmin"
}

variable "postgresql_admin_password" {
  type        = string
  description = "Administrator password for development PostgreSQL. Leave null to generate a random password."
  sensitive   = true
  default     = null
}

variable "postgresql_database_name" {
  type        = string
  description = "Default application database name for development."
  default     = "appdb"
}

variable "postgresql_sku_name" {
  type        = string
  description = "SKU for development PostgreSQL (Basic tier)."
  default     = "B_Standard_B1ms"
}

variable "postgresql_storage_mb" {
  type        = number
  description = "Storage size in MB for development PostgreSQL."
  default     = 32768
}

variable "postgresql_backup_retention_days" {
  type        = number
  description = "Backup retention days for development PostgreSQL."
  default     = 7
}

variable "postgresql_zone" {
  type        = string
  description = "Availability zone for development PostgreSQL (single-zone)."
  default     = "1"
}

variable "postgresql_private_dns_zone_name" {
  type        = string
  description = "Private DNS zone name used for private PostgreSQL access."
  default     = "private.postgres.database.azure.com"
}

variable "postgresql_firewall_rules" {
  type = map(object({
    start_ip_address = string
    end_ip_address   = string
  }))
  description = "Firewall rules for development PostgreSQL when public access is enabled."
  default     = {}
}

variable "acr_name" {
  type        = string
  description = "Azure Container Registry name for development."
  default     = "acrdevazk8s01"
}

variable "acr_sku" {
  type        = string
  description = "SKU for Azure Container Registry in development."
  default     = "Basic"
}

variable "acr_admin_enabled" {
  type        = bool
  description = "Enable admin user for Azure Container Registry in development."
  default     = false
}
