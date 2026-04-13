# AKS Terraform Module

Terraform module for provisioning an Azure Kubernetes Service (AKS) cluster for the azure-k8s-infrastructure project.

## Usage

```hcl
module "aks" {
  source = "../../modules/aks"

  # Example inputs (to be refined in later issues)
  # resource_group_name = azurerm_resource_group.main.name
  # location            = var.location
  # tags                = var.tags
}
```

## Inputs

Inputs will be defined in `variables.tf` as the AKS implementation is added (see issue #10).

## Outputs

Outputs will be defined in `outputs.tf` to expose cluster details for other modules.
