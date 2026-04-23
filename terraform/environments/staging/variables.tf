variable "location" {
  type        = string
  description = "Azure region for the staging environment."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name for staging."
}

variable "networking_vnet_name" {
  type        = string
  description = "Virtual network name for staging."
  default     = "vnet-staging-azk8s-01"
}

variable "networking_vnet_address_space" {
  type        = list(string)
  description = "Address space for the staging virtual network."
  default     = ["10.30.0.0/16"]
}

variable "networking_subnets" {
  type = map(object({
    address_prefixes = list(string)
    service_endpoints = optional(list(string), [
      "Microsoft.Storage",
      "Microsoft.KeyVault",
    ])
  }))
  description = "Subnet CIDR plan for staging."
  default = {
    aks = {
      address_prefixes = ["10.30.1.0/24"]
    }
    appgw = {
      address_prefixes = ["10.30.2.0/24"]
    }
    postgresql = {
      address_prefixes = ["10.30.3.0/24"]
    }
    elk = {
      address_prefixes = ["10.30.4.0/24"]
    }
  }
}

variable "aks_cluster_name" {
  type        = string
  description = "AKS cluster name for staging."
}

variable "aks_dns_prefix" {
  type        = string
  description = "AKS DNS prefix for staging."
}

variable "aks_node_count" {
  type        = number
  description = "Node count for the AKS default node pool in staging."
  default     = 2
}

variable "aks_vm_size" {
  type        = string
  description = "VM size for the AKS default node pool in staging."
  default     = "Standard_D2s_v5"
}

variable "kubernetes_version" {
  type        = string
  description = "Optional Kubernetes version for AKS. Use null to let Azure pick a default supported version."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags for staging resources."
  default     = {}
}

variable "aks_user_node_pools" {
  type = map(object({
    vm_size    = string
    node_count = number
    zones      = optional(list(string), [])
  }))
  description = "User node pools for the AKS cluster in staging."
  default     = {}
}

variable "postgresql_server_name" {
  type        = string
  description = "PostgreSQL flexible server name for staging."
  default     = "pg-staging-azk8s-01"
}

variable "postgresql_admin_login" {
  type        = string
  description = "Administrator login for staging PostgreSQL."
  default     = "postgresadmin"
}

variable "postgresql_admin_password" {
  type        = string
  description = "Administrator password for staging PostgreSQL. Leave null to generate a random password."
  sensitive   = true
  default     = null
}

variable "postgresql_database_name" {
  type        = string
  description = "Default application database name for staging."
  default     = "appdb"
}

variable "postgresql_sku_name" {
  type        = string
  description = "SKU for staging PostgreSQL (General Purpose tier)."
  default     = "GP_Standard_D2s_v3"
}

variable "postgresql_storage_mb" {
  type        = number
  description = "Storage size in MB for staging PostgreSQL."
  default     = 65536
}

variable "postgresql_backup_retention_days" {
  type        = number
  description = "Backup retention days for staging PostgreSQL."
  default     = 7
}

variable "postgresql_zone" {
  type        = string
  description = "Availability zone for staging PostgreSQL."
  default     = "1"
}

variable "postgresql_firewall_rules" {
  type = map(object({
    start_ip_address = string
    end_ip_address   = string
  }))
  description = "Firewall rules for staging PostgreSQL when public access is enabled."
  default = {
    allow_azure_services = {
      start_ip_address = "0.0.0.0"
      end_ip_address   = "0.0.0.0"
    }
  }
}
