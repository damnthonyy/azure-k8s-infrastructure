variable "location" {
  type        = string
  description = "Azure region for the production environment."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name for production."
}

variable "aks_cluster_name" {
  type        = string
  description = "AKS cluster name for production."
}

variable "aks_dns_prefix" {
  type        = string
  description = "AKS DNS prefix for production."
}

variable "aks_node_count" {
  type        = number
  description = "Node count for the AKS default node pool in production (used when autoscaling is disabled)."
  default     = 2
}

variable "aks_enable_autoscaling" {
  type        = bool
  description = "Enable autoscaling for the AKS default node pool in production."
  default     = true
}

variable "aks_min_node_count" {
  type        = number
  description = "Minimum number of nodes for autoscaling in production."
  default     = 3
}

variable "aks_max_node_count" {
  type        = number
  description = "Maximum number of nodes for autoscaling in production."
  default     = 10
}

variable "aks_vm_size" {
  type        = string
  description = "VM size for the AKS default node pool in production."
  default     = "Standard_D2s_v5"
}

variable "kubernetes_version" {
  type        = string
  description = "Optional Kubernetes version for AKS. Use null to let Azure pick a default supported version."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags for production resources."
  default     = {}
}
