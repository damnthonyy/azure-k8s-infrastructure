# Ansible Automation

This directory contains Ansible playbooks and roles for configuration management and deployment automation.

## Structure

```
ansible/
├── playbooks/              # Ansible playbooks
│   ├── configure-aks.yml   # Post-provisioning AKS configuration
│   ├── deploy-elk.yml      # Deploy ELK stack
│   ├── setup-monitoring.yml# Configure monitoring
│   └── configure-apps.yml  # Application deployment automation
├── roles/                  # Reusable Ansible roles
│   ├── kubernetes-config/  # Kubernetes configuration role
│   ├── elk-stack/         # ELK stack deployment role
│   └── app-deployment/    # Application deployment role
└── inventory/             # Inventory files per environment
    ├── dev.yml           # Development inventory
    ├── staging.yml       # Staging inventory
    └── production.yml    # Production inventory
```

## Prerequisites

- Ansible v2.15+
- Python 3.9+
- `kubectl` configured with cluster access
- Azure CLI for dynamic inventory

## Usage

### Run a Playbook

```bash
# Configure AKS cluster
ansible-playbook -i inventory/dev.yml playbooks/configure-aks.yml

# Deploy ELK stack
ansible-playbook -i inventory/dev.yml playbooks/deploy-elk.yml
```

### Check Syntax

```bash
ansible-playbook --syntax-check playbooks/configure-aks.yml
```

### Dry Run

```bash
ansible-playbook -i inventory/dev.yml playbooks/configure-aks.yml --check
```

## Inventory

Inventories are environment-specific and include:
- AKS cluster connection details
- Azure resource information
- Environment variables
- Service endpoints

## Roles

Each role follows Ansible best practices:
- `tasks/` - Task definitions
- `defaults/` - Default variables
- `handlers/` - Event handlers
- `templates/` - Jinja2 templates
- `files/` - Static files

## Variables

Variables are organized by precedence:
1. Inventory variables (highest)
2. Playbook variables
3. Role defaults (lowest)

## Best Practices

1. **Idempotent** - Playbooks can be run multiple times safely
2. **Tags** - Use tags for selective execution
3. **Check mode** - Always test with `--check` first
4. **Vault** - Sensitive data encrypted with Ansible Vault
5. **Documentation** - Each playbook includes header documentation
