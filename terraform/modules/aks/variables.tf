variable "cluster_name" {
  type        = string
  description = "Name of the AKS cluster."
}

variable "dns_prefix" {
  type        = string
  description = "DNS prefix for the AKS cluster."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the existing resource group."
}

variable "location" {
  type        = string
  description = "Azure country location for the AKS cluster."
}

variable "node_count" {
  type        = number
  description = "Number of nodes in the default node pool (used when autoscaling is disabled)."
  default     = 2
}

variable "enable_autoscaling" {
  type        = bool
  description = "Enable cluster autoscaling on the system node pool."
  default     = false
}

variable "min_node_count" {
  type        = number
  description = "Minimum number of nodes for autoscaling (e.g., 2)."
  default     = 2
}

variable "max_node_count" {
  type        = number
  description = "Maximum number of nodes for autoscaling (e.g., 10)."
  default     = 10
}

variable "vm_size" {
  type        = string
  description = "VM size for the nodes in the default node pool."
  default     = "Standard_D2s_v5"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log Analytics Workspace ID for Azure Monitor integration."
}

variable "tags" {
  type        = map(string)
  description = "Tags for Azure resources."
  default     = {}
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version for the AKS cluster."
  default     = null
}

variable "user_node_pools" {
  type = map(object({
    vm_size    = string
    node_count = number
  }))
  description = "Additional user node pools to create on the AKS cluster. Keys are used as node pool names."
  default     = {}
}
