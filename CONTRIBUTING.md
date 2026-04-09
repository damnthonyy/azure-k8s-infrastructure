# Contributing to Azure Kubernetes Infrastructure

Thank you for your interest in contributing! This document provides guidelines and workflows for contributing to this project.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)

## 🤝 Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help others learn and grow
- Maintain professional communication

## 🚀 Getting Started

### 1. Fork and Clone

```bash
# Clone the repository
git clone https://github.com/<your-org>/azure-k8s-infrastructure.git
cd azure-k8s-infrastructure
```

### 2. Set Up Development Environment

```bash
# Install required tools (see README.md for versions)
# - Azure CLI
# - Terraform
# - Ansible
# - kubectl
# - Docker
# - Helm

# Verify installations
az --version
terraform --version
ansible --version
kubectl version --client
docker --version
helm version
```

### 3. Configure Git

```bash
# Set up Git hooks (optional)
git config core.hooksPath .githooks

# Configure your Git identity
git config user.name "Your Name"
git config user.email "your.email@example.com"
```

## 🔄 Development Workflow

We use a **feature branch workflow** with GitHub issues:

### Step 1: Pick an Issue

1. Browse [open issues](https://github.com/<your-org>/azure-k8s-infrastructure/issues)
2. Comment on the issue to claim it
3. Wait for assignment or approval

### Step 2: Create Feature Branch

```bash
# Always branch from develop
git checkout develop
git pull origin develop

# Create feature branch using issue number
# Format: feat/<issue-number>-short-description
git checkout -b feat/15-add-postgresql-module

# Or for bug fixes
git checkout -b fix/23-terraform-state-lock
```

### Step 3: Make Changes

- Write clean, modular code
- Add comments explaining complex logic
- Follow the coding standards below
- Test your changes locally

### Step 4: Commit Regularly

Make small, focused commits:

```bash
# Stage your changes
git add <files>

# Commit with descriptive message
git commit -m "feat(terraform): add PostgreSQL flexible server module

- Create module structure with variables
- Configure private endpoint
- Add backup retention configuration
- Include high availability options

Fixes #15"
```

### Step 5: Create Draft PR

```bash
# Push your branch
git push origin feat/15-add-postgresql-module
```

Then on GitHub:
1. Create a **Draft Pull Request**
2. Link it to the issue (use "Closes #15" in PR description)
3. Add appropriate labels
4. Continue making commits

### Step 6: Request Review

Once your changes are complete:
1. Mark PR as "Ready for review"
2. Request reviewers
3. Address feedback promptly
4. Keep the PR updated with develop

### Step 7: Merge

After approval:
- Squash and merge (for small features)
- Merge commit (for larger features with multiple logical commits)
- Delete the feature branch

## 🔐 Branch Protection

- Direct pushes to `main` and `develop` are restricted
- All changes must go through pull requests
- At least **1 approving review** is required
- CI workflow **"CI - Continuous Integration"** must pass (all jobs)
- Branch must be up to date with the target branch before merging

## 📝 Commit Guidelines

### Commit Message Format

```
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

### Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, no logic change)
- **refactor**: Code refactoring
- **test**: Adding or updating tests
- **chore**: Maintenance tasks (dependencies, configs)
- **perf**: Performance improvements
- **ci**: CI/CD pipeline changes

### Scopes

- **terraform**: Terraform modules and configurations
- **ansible**: Ansible playbooks and roles
- **kubernetes**: Kubernetes manifests
- **github-actions**: CI/CD workflows
- **backend**: .NET Core application
- **frontend**: Next.js application
- **elk**: ELK stack configuration
- **docs**: Documentation
- **scripts**: Helper scripts

### Examples

```bash
# Good commit messages
feat(terraform): add AKS cluster module with auto-scaling
fix(ansible): correct ELK memory configuration for production
docs(readme): update deployment instructions
chore(deps): upgrade Terraform to v1.6.0

# Bad commit messages (avoid these)
update files
fix bug
changes
WIP
```

### Reference Issues

Always reference the related issue:

```bash
# In commit message
Fixes #42
Closes #123
Relates to #99

# In PR description
This PR addresses #42 by implementing...
```

## 🔍 Pull Request Process

### Before Creating PR

- [ ] Code follows project conventions
- [ ] All tests pass locally
- [ ] Comments added for complex logic
- [ ] Documentation updated (if needed)
- [ ] No sensitive data committed
- [ ] Branch is up to date with develop

### PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Related Issue
Closes #<issue-number>

## Changes Made
- Change 1
- Change 2
- Change 3

## Testing
How to test these changes:
1. Step 1
2. Step 2

## Screenshots (if applicable)
Add screenshots

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added
- [ ] Documentation updated
- [ ] No new warnings
- [ ] Tests added/updated
```

### Review Process

1. **Automated Checks**: CI/CD pipelines must pass
2. **Peer Review**: At least one approval required
3. **Testing**: Changes tested in dev environment
4. **Documentation**: Relevant docs updated

### Addressing Feedback

```bash
# Make requested changes
git add <files>
git commit -m "refactor: address PR feedback

- Improved variable naming
- Added error handling
- Updated documentation"

# Push changes
git push origin feat/15-add-postgresql-module
```

## 🎨 Coding Standards

### Terraform

```hcl
# Use consistent naming: <resource>_<name>
resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-${var.environment}-rg"
  location = var.location
  
  # Always add tags for cost tracking
  tags = var.tags
}

# Variables: use descriptions and validation
variable "environment" {
  description = "Environment name (dev, staging, production)"
  type        = string
  
  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be dev, staging, or production."
  }
}

# Outputs: include descriptions
output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.name
}
```

### Ansible

```yaml
---
# Use descriptive task names
- name: Configure Elasticsearch memory settings
  lineinfile:
    path: /etc/elasticsearch/jvm.options
    regexp: '^-Xms'
    line: '-Xms{{ elasticsearch_heap_size }}'
    state: present
  # Add comment explaining why this is needed
  # Heap size should be 50% of available memory but not exceed 31GB
  notify: restart elasticsearch
```

### Kubernetes

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend-api
  namespace: production
  # Labels for organization and selection
  labels:
    app: backend
    component: api
    version: v1.0.0
spec:
  replicas: 3
  selector:
    matchLabels:
      app: backend
      component: api
  template:
    metadata:
      labels:
        app: backend
        component: api
        version: v1.0.0
    spec:
      containers:
      - name: api
        image: myacr.azurecr.io/backend:latest
        # Always specify resource limits and requests
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        # Include liveness and readiness probes
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
```

### Comments

```bash
# Good comments explain WHY, not WHAT
# This timeout is set to 300s because Azure API Gateway
# can take up to 5 minutes to provision in production
resource "azurerm_application_gateway" "main" {
  # ... configuration
}

# Avoid obvious comments
# Bad: Creates a resource group
# Good: Main resource group for all infrastructure components
resource "azurerm_resource_group" "main" {
  # ...
}
```

## 🧪 Testing

### Terraform

```bash
# Format check
terraform fmt -check -recursive

# Validation
terraform validate

# Plan (dry-run)
terraform plan
```

### Ansible

```bash
# Syntax check
ansible-playbook --syntax-check playbooks/configure-aks.yml

# Dry run
ansible-playbook -i inventory/dev.yml playbooks/configure-aks.yml --check
```

### Kubernetes

```bash
# Validate manifests
kubectl apply --dry-run=client -f kubernetes/backend/

# Lint with kubeval (if installed)
kubeval kubernetes/backend/*.yaml
```

## 📚 Additional Resources

- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [Kubernetes Best Practices](https://kubernetes.io/docs/concepts/configuration/overview/)
- [Conventional Commits](https://www.conventionalcommits.org/)

## ❓ Questions?

If you have questions:
1. Check existing documentation
2. Search closed issues
3. Ask in issue comments
4. Create a new discussion

Thank you for contributing! 🎉
