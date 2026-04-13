# Azure Kubernetes Infrastructure

> Production-ready infrastructure for deploying .NET Core backend, Next.js frontend, and PostgreSQL database on Azure Kubernetes Service (AKS) using Terraform and Ansible.

## 🏗️ Architecture Overview

This project provisions a complete cloud infrastructure on Microsoft Azure with:

- **Backend**: .NET Core Web API running in containers
- **Frontend**: Next.js application with server-side rendering
- **Database**: Azure Database for PostgreSQL (Flexible Server)
- **Container Platform**: Azure Kubernetes Service (AKS)
- **Container Registry**: Azure Container Registry (ACR)
- **Monitoring**: ELK Stack (Elasticsearch, Logstash, Kibana)
- **CI/CD**: GitHub Actions
- **Secrets Management**: Azure Key Vault

## 🌍 Environments

- **Development**: Smaller resources for testing and development
- **Staging**: Production-like environment for pre-release testing
- **Production**: High availability, auto-scaling, multi-zone deployment

## 📁 Project Structure

```
azure-k8s-infrastructure/
├── terraform/              # Infrastructure as Code
│   ├── modules/           # Reusable Terraform modules
│   └── environments/      # Environment-specific configurations
├── ansible/               # Configuration management
│   ├── playbooks/        # Automation playbooks
│   └── roles/            # Reusable roles
├── kubernetes/            # Kubernetes manifests
│   ├── backend/          # Backend deployment configs
│   ├── frontend/         # Frontend deployment configs
│   ├── ingress/          # Ingress controller configs
│   └── elk/              # ELK stack configs
├── applications/          # Application source code
│   ├── backend/          # .NET Core API
│   └── frontend/         # Next.js application
├── .github/workflows/     # CI/CD pipelines
└── scripts/              # Helper scripts
```

## 🚀 Quick Start

### Prerequisites

Ensure you have the following tools installed:

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) (v2.40+)
- [Terraform](https://www.terraform.io/downloads) (v1.5+)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) (v2.15+)
- [kubectl](https://kubernetes.io/docs/tasks/tools/) (v1.27+)
- [Docker](https://docs.docker.com/get-docker/) (v24+)
- [Helm](https://helm.sh/docs/intro/install/) (v3.12+)
- [GitHub CLI](https://cli.github.com/) (optional, for issue management)

### Initial Setup

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd azure-k8s-infrastructure
   ```

2. **Azure Authentication**
   ```bash
   az login
   az account set --subscription <your-subscription-id>
   ```

3. **Create Service Principal for Terraform**
   ```bash
   ./scripts/create-service-principal.sh
   ```

4. **Initialize Terraform**
   ```bash
   ./scripts/init-terraform.sh
   ```

5. **Configure environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your values
   ```

## 📋 Deployment

### Deploy Infrastructure (Terraform)

```bash
# Navigate to desired environment
cd terraform/environments/dev

# Initialize Terraform
terraform init

# Plan the deployment
terraform plan -out=tfplan

# Apply the changes
terraform apply tfplan
```

### Configure AKS (Ansible)

```bash
# Configure kubectl context
./scripts/setup-kubectl.sh dev

# Run Ansible playbooks
cd ansible
ansible-playbook -i inventory/dev.yml playbooks/configure-aks.yml
ansible-playbook -i inventory/dev.yml playbooks/deploy-elk.yml
```

### Deploy Applications (GitHub Actions)

Push to the appropriate branch to trigger CI/CD:
- `develop` → Deploys to Development
- `staging` → Deploys to Staging
- `main` → Deploys to Production (with approval)

## 🔐 Security

- **Secrets Management**: All secrets stored in Azure Key Vault
- **Network Security**: Private endpoints and network policies
- **RBAC**: Azure AD integration for authentication
- **SSL/TLS**: Automatic certificate management with cert-manager
- **Container Scanning**: Vulnerability scanning in CI/CD pipeline

## 📊 Monitoring & Logging

- **Application Logs**: Centralized in ELK Stack
- **Metrics**: Prometheus and Grafana
- **Alerts**: Configured in Elasticsearch Watcher
- **Dashboards**: Pre-configured Kibana dashboards

Access Kibana:
```bash
kubectl port-forward -n elk-stack svc/kibana 5601:5601
# Open http://localhost:5601
```

## 🧪 Testing

```bash
# Run Terraform validation
terraform validate

# Run Ansible syntax check
ansible-playbook --syntax-check playbooks/*.yml

# Run Kubernetes manifest validation
kubectl apply --dry-run=client -f kubernetes/
```

## 📖 Documentation

- [Architecture Documentation](docs/architecture.md)
- [Deployment Guide](docs/deployment.md)
- [Troubleshooting Guide](docs/troubleshooting.md)
- [Contributing Guidelines](CONTRIBUTING.md)

## 🤝 Contributing

We follow a structured workflow with GitHub issues and pull requests:

1. Check existing issues or create a new one
2. Create a feature branch: `feat/<issue-number>-description`
3. Make your changes with descriptive commits
4. Create a draft PR and link it to the issue
5. Request review when ready
6. Merge after approval

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Team & Support

For questions or support:
- Create an issue in this repository
- Contact the DevOps team
- Check the [troubleshooting guide](docs/troubleshooting.md)

## 🗺️ Roadmap

- [ ] Multi-region deployment
- [ ] Advanced monitoring with APM
- [ ] Chaos engineering tests
- [ ] Cost optimization automation
- [ ] Infrastructure drift detection

---

**Built by Antoine Mahassadi**
