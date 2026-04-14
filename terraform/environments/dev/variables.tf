variable "location" {
  type        = string
  description = "Azure region for the development environment."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name for development."
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
