output "cluster_name" {
  value       = azurerm_kubernetes_cluster.this.name
  description = "Name of the AKS cluster."
}

output "cluster_id" {
  value       = azurerm_kubernetes_cluster.this.id
  description = "ID of the AKS cluster."
}
