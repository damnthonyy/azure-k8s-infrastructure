# Terraform Infrastructure

This directory contains all Terraform code for provisioning Azure infrastructure.

## Structure

```
terraform/
├── modules/          # Reusable Terraform modules
│   ├── aks/         # Azure Kubernetes Service
│   ├── postgresql/  # Azure Database for PostgreSQL
│   ├── acr/         # Azure Container Registry
│   ├── networking/  # VNet, Subnets, NSGs
│   ├── keyvault/    # Azure Key Vault
│   └── storage/     # Azure Storage Account
└── environments/     # Environment-specific configurations
    ├── dev/         # Development environment
    ├── staging/     # Staging environment
    └── production/  # Production environment
```

## Usage

### Prerequisites

- Terraform v1.5+
- Azure CLI authenticated (`az login`)
- Service Principal credentials configured

### Initialize Terraform

```bash
cd terraform/environments/dev
terraform init
```

### Plan Changes

```bash
terraform plan -out=tfplan
```

### Apply Changes

```bash
terraform apply tfplan
```

## Module Documentation

Each module contains:
- `main.tf` - Primary resource definitions
- `variables.tf` - Input variables with validation
- `outputs.tf` - Output values
- `README.md` - Module-specific documentation

## Best Practices

1. **Always use remote state** - State is stored in Azure Storage
2. **Use workspaces** - Separate environments with Terraform workspaces
3. **Variables validation** - All variables include validation rules
4. **Tagging** - All resources are tagged with environment and project info
5. **Modules** - Reusable modules for consistency across environments

## State Management

Remote state is configured in `backend.tf`:
- Storage Account: Defined in backend configuration
- Container: `tfstate`
- Key: `{environment}/terraform.tfstate`

## Security

- Credentials stored in Azure Key Vault
- Service Principal with least privilege
- Network security groups restrict access
- Private endpoints for sensitive resources
