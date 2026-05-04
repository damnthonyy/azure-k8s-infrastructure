variable "server_name" {
  type        = string
  description = "Name of the PostgreSQL flexible server."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group where PostgreSQL will be created."
}

variable "location" {
  type        = string
  description = "Azure region where PostgreSQL will be created."
}

variable "postgresql_version" {
  type        = string
  description = "PostgreSQL major version."
  default     = "13"
}

variable "administrator_login" {
  type        = string
  description = "Administrator username for PostgreSQL."
}

variable "administrator_password" {
  type        = string
  description = "Administrator password for PostgreSQL. If null, a random password is generated."
  sensitive   = true
  default     = null
}

variable "database_name" {
  type        = string
  description = "Default database name to create."
  default     = "appdb"
}

variable "database_charset" {
  type        = string
  description = "Character set for the default database."
  default     = "UTF8"
}

variable "database_collation" {
  type        = string
  description = "Collation for the default database."
  default     = "en_US.utf8"
}

variable "sku_name" {
  type        = string
  description = "PostgreSQL SKU name (for example B_Standard_B1ms, GP_Standard_D2s_v3)."
}

variable "storage_mb" {
  type        = number
  description = "Storage size for PostgreSQL in MB."
  default     = 32768
}

variable "backup_retention_days" {
  type        = number
  description = "Number of days backups are retained."
  default     = 7
}

variable "geo_redundant_backup_enabled" {
  type        = bool
  description = "Enable geo-redundant backup."
  default     = false
}

variable "firewall_rules" {
  type = map(object({
    start_ip_address = string
    end_ip_address   = string
  }))
  description = "Firewall rules when public network access is enabled."
  default     = {}
}

variable "zone" {
  type        = string
  description = "Primary availability zone."
  default     = null
}

variable "high_availability_mode" {
  type        = string
  description = "High availability mode: SameZone, ZoneRedundant, or null to disable."
  default     = null

  validation {
    condition     = var.high_availability_mode == null ? true : contains(["SameZone", "ZoneRedundant"], var.high_availability_mode)
    error_message = "high_availability_mode must be null, SameZone, or ZoneRedundant."
  }
}

variable "standby_availability_zone" {
  type        = string
  description = "Standby availability zone used when high availability is enabled."
  default     = null
}

variable "delegated_subnet_id" {
  type        = string
  description = "Delegated subnet ID for private networking. Leave null for public networking."
  default     = null
}

variable "private_dns_zone_id" {
  type        = string
  description = "Private DNS Zone ID used with delegated_subnet_id."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags for PostgreSQL resources."
  default     = {}
}
