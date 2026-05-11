variable "resource_group_name" {
  type        = string
  description = "Resource group where Application Gateway is created."
}

variable "location" {
  type        = string
  description = "Azure region for Application Gateway."
}

variable "vnet_name" {
  type        = string
  description = "Virtual network name (used for default naming)."
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID where Application Gateway frontend is deployed."
}

variable "app_gateway_name" {
  type        = string
  description = "Application Gateway name. If null, uses <vnet_name>-appgw."
  default     = null
}

variable "app_gateway_public_ip_name" {
  type        = string
  description = "Public IP name for Application Gateway. If null, uses <vnet_name>-appgw-pip."
  default     = null
}

variable "sku_name" {
  type        = string
  description = "SKU name for Application Gateway."
  default     = "Standard_v2"

  validation {
    condition     = contains(["Standard_v2", "WAF_v2"], var.sku_name)
    error_message = "sku_name must be Standard_v2 or WAF_v2."
  }
}

variable "sku_tier" {
  type        = string
  description = "SKU tier for Application Gateway."
  default     = "Standard_v2"

  validation {
    condition     = contains(["Standard_v2", "WAF_v2"], var.sku_tier)
    error_message = "sku_tier must be Standard_v2 or WAF_v2."
  }
}

variable "capacity" {
  type        = number
  description = "Number of Application Gateway instances."
  default     = 2

  validation {
    condition     = var.capacity >= 1 && var.capacity <= 125
    error_message = "capacity must be between 1 and 125."
  }
}

variable "backend_pool_name" {
  type        = string
  description = "Backend pool name."
  default     = "appgw-backend-pool"
}

variable "enable_waf" {
  type        = bool
  description = "Enable Web Application Firewall."
  default     = false
}

variable "waf_mode" {
  type        = string
  description = "WAF mode: Detection or Prevention."
  default     = "Detection"

  validation {
    condition     = contains(["Detection", "Prevention"], var.waf_mode)
    error_message = "waf_mode must be Detection or Prevention."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags for Application Gateway resources."
  default     = {}
}
