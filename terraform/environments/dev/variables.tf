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
      address_prefixes = ["10.20.3.0/24"]
    }
    elk = {
      address_prefixes = ["10.20.4.0/24"]
    }
  }
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

variable "postgresql_firewall_rules" {
  type = map(object({
    start_ip_address = string
    end_ip_address   = string
  }))
  description = "Firewall rules for development PostgreSQL when public access is enabled."
  default = {
    allow_azure_services = {
      start_ip_address = "0.0.0.0"
      end_ip_address   = "0.0.0.0"
    }
  }
}
