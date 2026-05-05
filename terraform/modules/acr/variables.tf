variable "resource_group_name" {
  type        = string
  description = "Name of the resource group where the ACR will be created."
}

variable "location" {
  type        = string
  description = "Azure region for the ACR."
}

variable "registry_name" {
  type        = string
  description = "Name of the Azure Container Registry."
}

variable "sku" {
  type        = string
  description = "ACR SKU."
  default     = "Standard"
}

variable "admin_enabled" {
  type        = bool
  description = "Enable admin user for ACR."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the ACR."
  default     = {}
}
