#!/bin/bash

# Script to create GitHub issues from todos
# This script creates all issues for the Azure K8s Infrastructure project

set -e  # Exit on error

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Creating GitHub issues for Azure K8s Infrastructure...${NC}\n"

# Phase 0: Git Repository Initialization (already completed some)
echo -e "${GREEN}Phase 0: Git Repository Initialization${NC}"

gh issue create --title "Create GitHub issues for todos" \
  --body "## Description
Create 60 GitHub issues from all todos with proper labels, descriptions, and acceptance criteria.

## Tasks
- Generate issues for all phases (1-12)
- Apply appropriate labels (infrastructure, kubernetes, cicd, security, docs)
- Add detailed descriptions and acceptance criteria
- Link related issues with dependencies

## Acceptance Criteria
- [ ] All 60 issues created
- [ ] Proper labels applied
- [ ] Descriptions include context and requirements
- [ ] Dependencies documented" \
  --label "chore,automation" \
  --assignee "@me"

gh issue create --title "Setup GitHub Project board" \
  --body "## Description
Create GitHub Project board with automation, columns, and link all issues to the project.

## Tasks
- Create new Project board
- Add columns: Backlog, Ready, In Progress, Review, Done
- Configure automation rules
- Link all issues to the board
- Set up filters and views

## Acceptance Criteria
- [ ] Project board created
- [ ] All issues linked
- [ ] Automation configured
- [ ] Views set up for filtering by phase/label" \
  --label "chore,github" \
  --assignee "@me"

gh issue create --title "Configure branch protection rules" \
  --body "## Description
Set up branch protection rules for main and develop branches requiring PR reviews, passing CI checks, and up-to-date branches before merging.

## Tasks
- Configure protection for \`main\` branch
- Configure protection for \`develop\` branch
- Require pull request reviews (min 1 approval)
- Require status checks to pass
- Require branches to be up to date

## Acceptance Criteria
- [ ] Main branch protected
- [ ] Develop branch protected
- [ ] PR reviews required
- [ ] CI checks required before merge" \
  --label "chore,github,security" \
  --assignee "@me"

# Phase 1: Initial Setup & Repository Structure
echo -e "${GREEN}Phase 1: Initial Setup & Repository Structure${NC}"

gh issue create --title "Create repository structure" \
  --body "## Description
Create all necessary folders for terraform/, ansible/, kubernetes/, applications/, .github/workflows/, and scripts/ with proper organization.

## Tasks
- Create Terraform module directories
- Create Ansible roles and playbooks structure
- Create Kubernetes manifests directories
- Create applications directories (backend/frontend)
- Add README.md files to explain each directory

## Acceptance Criteria
- [ ] All directories created as per spec
- [ ] Each major directory has a README
- [ ] Structure follows best practices
- [ ] Directory permissions set correctly

## Phase
Phase 1: Initial Setup" \
  --label "infrastructure,terraform,ansible" \
  --assignee "@me"

gh issue create --title "Configure Terraform remote state backend" \
  --body "## Description
Set up Azure Storage Account for Terraform remote state management. Create storage account, container, and configure backend.tf.

## Tasks
- Create Azure Storage Account
- Create blob container for state files
- Configure backend.tf with remote state
- Set up state locking with lease
- Document backend configuration

## Acceptance Criteria
- [ ] Storage account created
- [ ] Container created
- [ ] backend.tf configured
- [ ] State locking working
- [ ] Documentation complete

## Phase
Phase 1: Initial Setup

## Dependencies
Requires Azure Service Principal (#5)" \
  --label "infrastructure,terraform,azure" \
  --assignee "@me"

gh issue create --title "Create Azure Service Principal for Terraform" \
  --body "## Description
Create Azure Service Principal with Contributor role for Terraform to authenticate with Azure. Store credentials securely.

## Tasks
- Create Service Principal via Azure CLI
- Assign Contributor role at subscription level
- Store credentials in Azure Key Vault
- Configure credentials for CI/CD
- Document credential rotation procedure

## Acceptance Criteria
- [ ] Service Principal created
- [ ] Contributor role assigned
- [ ] Credentials stored securely
- [ ] GitHub Secrets configured
- [ ] Rotation procedure documented

## Phase
Phase 1: Initial Setup

## Security Notes
- Never commit credentials to git
- Use GitHub Secrets for CI/CD
- Set up credential rotation schedule" \
  --label "infrastructure,azure,security" \
  --assignee "@me"

gh issue create --title "Document and verify tool installations" \
  --body "## Description
Document and verify installation of Terraform, Ansible, kubectl, Azure CLI, Docker, and Helm on local machine.

## Tools Required
- Azure CLI (v2.40+)
- Terraform (v1.5+)
- Ansible (v2.15+)
- kubectl (v1.27+)
- Docker (v24+)
- Helm (v3.12+)

## Tasks
- Create installation guide for each tool
- Add version verification script
- Document tool configurations
- Create troubleshooting section

## Acceptance Criteria
- [ ] Installation guide complete
- [ ] All tools installed and verified
- [ ] Version check script created
- [ ] Troubleshooting guide added

## Phase
Phase 1: Initial Setup" \
  --label "documentation,chore" \
  --assignee "@me"

# Phase 2: Terraform Infrastructure - Core Resources
echo -e "${GREEN}Phase 2: Terraform Infrastructure - Core Resources${NC}"

gh issue create --title "Build Terraform module structure" \
  --body "## Description
Create base structure for all Terraform modules with proper variables, outputs, and main.tf files for aks, postgresql, acr, networking, keyvault, and storage.

## Modules to Create
- AKS (Azure Kubernetes Service)
- PostgreSQL (Flexible Server)
- ACR (Container Registry)
- Networking (VNet, Subnets, NSGs)
- Key Vault
- Storage Account

## Tasks
- Create module directory structure
- Add variables.tf for each module
- Add outputs.tf for each module
- Add main.tf with resource definitions
- Add README.md for each module

## Acceptance Criteria
- [ ] All module directories created
- [ ] Variables defined with validation
- [ ] Outputs documented
- [ ] README for each module
- [ ] Follows Terraform best practices

## Phase
Phase 2: Core Infrastructure" \
  --label "infrastructure,terraform" \
  --assignee "@me"

gh issue create --title "Create VNet and networking module" \
  --body "## Description
Build Terraform module for VNet, subnets (AKS, Application Gateway, PostgreSQL, ELK), NSGs, and network security rules with proper CIDR planning.

## Networking Components
- Virtual Network
- Subnets: AKS, App Gateway, PostgreSQL, ELK
- Network Security Groups
- Route tables
- Private endpoints

## CIDR Planning
- VNet: /16
- AKS subnet: /20
- App Gateway subnet: /24
- PostgreSQL subnet: /24
- ELK subnet: /24

## Acceptance Criteria
- [ ] VNet module created
- [ ] All subnets configured
- [ ] NSG rules defined
- [ ] CIDR ranges properly planned
- [ ] Module tested

## Phase
Phase 2: Core Infrastructure

## Dependencies
Requires module structure (#7)" \
  --label "infrastructure,terraform,networking" \
  --assignee "@me"

gh issue create --title "Setup Azure Container Registry module" \
  --body "## Description
Create Terraform module for Azure Container Registry with Premium SKU for geo-replication, admin access disabled, and Azure AD authentication.

## Configuration
- SKU: Premium (for geo-replication)
- Admin access: Disabled
- Authentication: Azure AD
- Public network access: Disabled (private endpoint)
- Geo-replication: Enabled for production

## Acceptance Criteria
- [ ] ACR module created
- [ ] Premium SKU configured
- [ ] Admin access disabled
- [ ] Azure AD auth enabled
- [ ] Private endpoint configured
- [ ] Geo-replication ready

## Phase
Phase 2: Core Infrastructure

## Dependencies
Requires module structure (#7)" \
  --label "infrastructure,terraform,azure" \
  --assignee "@me"

gh issue create --title "Configure Azure Key Vault module" \
  --body "## Description
Build Terraform module for Azure Key Vault with soft-delete enabled, RBAC access policies, and network restrictions configured.

## Configuration
- Soft delete: Enabled (90 days)
- Purge protection: Enabled
- Access model: RBAC
- Network access: Private endpoint only
- Diagnostic logging: Enabled

## Acceptance Criteria
- [ ] Key Vault module created
- [ ] Soft delete enabled
- [ ] RBAC configured
- [ ] Private endpoint configured
- [ ] Diagnostic logging enabled
- [ ] Secrets rotation policy defined

## Phase
Phase 2: Core Infrastructure

## Dependencies
Requires module structure (#7)" \
  --label "infrastructure,terraform,security" \
  --assignee "@me"

gh issue create --title "Setup Azure Storage module" \
  --body "## Description
Create Terraform module for Azure Storage Account for artifacts, backups, and Terraform state with encryption and private endpoints.

## Configuration
- Replication: ZRS (Zone-redundant)
- Encryption: Microsoft-managed keys
- Access tier: Hot
- Private endpoints: Enabled
- Containers: tfstate, backups, artifacts

## Acceptance Criteria
- [ ] Storage module created
- [ ] ZRS replication configured
- [ ] Encryption enabled
- [ ] Private endpoints configured
- [ ] Containers defined
- [ ] Lifecycle policies set

## Phase
Phase 2: Core Infrastructure

## Dependencies
Requires module structure (#7)" \
  --label "infrastructure,terraform,azure" \
  --assignee "@me"

# Phase 3: Terraform Infrastructure - Compute & Database
echo -e "${GREEN}Phase 3: Terraform Infrastructure - Compute & Database${NC}"

gh issue create --title "Create AKS cluster Terraform module" \
  --body "## Description
Build Terraform module for AKS with auto-scaling, Azure AD integration, managed identity, network plugin Azure CNI, and monitoring enabled.

## Configuration
- Network plugin: Azure CNI
- Managed identity: System-assigned
- Azure AD: Enabled
- Auto-scaling: Enabled
- Node pools: System and user
- Monitoring: Azure Monitor for containers

## Node Pool Specs
- Dev: 2 nodes, Standard_D2s_v3
- Staging: 2-3 nodes, Standard_D4s_v3
- Production: 3-10 nodes, Standard_D8s_v3, multi-zone

## Acceptance Criteria
- [ ] AKS module created
- [ ] Azure CNI configured
- [ ] Managed identity enabled
- [ ] Auto-scaling configured
- [ ] Node pools defined
- [ ] Monitoring enabled

## Phase
Phase 3: Compute & Database

## Dependencies
Requires networking module (#8)" \
  --label "infrastructure,terraform,kubernetes" \
  --assignee "@me"

gh issue create --title "Setup PostgreSQL Flexible Server module" \
  --body "## Description
Create Terraform module for Azure Database for PostgreSQL Flexible Server with version 14+, private endpoint, automated backups, and HA configuration for production.

## Configuration
- Version: PostgreSQL 14 or 15
- SKU: Varies by environment
- Storage: Auto-grow enabled
- Backup retention: 7-30 days
- HA: Zone-redundant for production
- Private endpoint: Enabled

## Environment Specs
- Dev: Burstable B1ms, 32GB
- Staging: GeneralPurpose D2s_v3, 128GB
- Production: MemoryOptimized E4ds_v4, 256GB, HA

## Acceptance Criteria
- [ ] PostgreSQL module created
- [ ] Version 14+ configured
- [ ] Private endpoint enabled
- [ ] Automated backups configured
- [ ] HA enabled for production
- [ ] Firewall rules defined

## Phase
Phase 3: Compute & Database

## Dependencies
Requires networking module (#8)" \
  --label "infrastructure,terraform,database" \
  --assignee "@me"

gh issue create --title "Configure Application Gateway module" \
  --body "## Description
Build Terraform module for Application Gateway v2 with WAF, SSL termination, and health probes for ingress controller.

## Configuration
- SKU: Standard_v2 / WAF_v2
- Tier: Standard_v2 / WAF_v2
- Capacity: Auto-scaling 2-10
- SSL policy: Modern
- WAF: Enabled for production
- Health probes: Configured

## Acceptance Criteria
- [ ] Application Gateway module created
- [ ] WAF enabled
- [ ] SSL termination configured
- [ ] Health probes defined
- [ ] Backend pools configured
- [ ] Auto-scaling enabled

## Phase
Phase 3: Compute & Database

## Dependencies
Requires networking module (#8)" \
  --label "infrastructure,terraform,networking" \
  --assignee "@me"

gh issue create --title "Link AKS to VNet with private endpoints" \
  --body "## Description
Configure AKS cluster to use VNet integration, private cluster endpoint, authorized IP ranges, and service endpoints for Azure services.

## Configuration
- VNet integration: Enabled
- Private cluster: Enabled for production
- Authorized IP ranges: Configured
- Service endpoints: Key Vault, Storage, PostgreSQL
- Network policy: Azure

## Acceptance Criteria
- [ ] AKS VNet integration configured
- [ ] Private endpoint enabled
- [ ] Authorized IPs configured
- [ ] Service endpoints enabled
- [ ] Network policy applied

## Phase
Phase 3: Compute & Database

## Dependencies
Requires AKS module (#12) and networking (#8)" \
  --label "infrastructure,terraform,networking" \
  --assignee "@me"

echo -e "${BLUE}\n✓ Created infrastructure setup issues${NC}"
echo -e "${BLUE}Creating Phase 4-12 issues...${NC}\n"

# Phase 4: Environment Configuration
echo -e "${GREEN}Phase 4: Environment Configuration${NC}"

gh issue create --title "Configure dev environment with Terraform" \
  --body "## Description
Create Terraform workspace and configuration for development with smaller resources (2-node AKS, Basic PostgreSQL tier, single-zone deployment).

## Resources
- AKS: 2 nodes, Standard_D2s_v3
- PostgreSQL: Burstable B1ms
- Zone redundancy: Disabled
- Cost optimization: Enabled

## Tasks
- Create dev workspace
- Configure dev.tfvars
- Set resource limits
- Test deployment

## Acceptance Criteria
- [ ] Workspace created
- [ ] tfvars configured
- [ ] Cost-optimized settings applied
- [ ] Successfully deployed

## Phase
Phase 4: Environments

## Dependencies
Requires all modules (#12, #13, #14)" \
  --label "infrastructure,terraform,environment" \
  --assignee "@me"

gh issue create --title "Configure staging environment with Terraform" \
  --body "## Description
Create Terraform workspace and configuration for staging with medium resources (2-3 node AKS, General Purpose PostgreSQL, single-zone).

## Resources
- AKS: 2-3 nodes, Standard_D4s_v3
- PostgreSQL: GeneralPurpose D2s_v3
- Zone redundancy: Optional
- Production-like: Yes

## Tasks
- Create staging workspace
- Configure staging.tfvars
- Mirror production config
- Test deployment

## Acceptance Criteria
- [ ] Workspace created
- [ ] tfvars configured
- [ ] Production-like settings
- [ ] Successfully deployed

## Phase
Phase 4: Environments

## Dependencies
Requires all modules (#12, #13, #14)" \
  --label "infrastructure,terraform,environment" \
  --assignee "@me"

gh issue create --title "Configure production environment with HA" \
  --body "## Description
Create Terraform workspace and configuration for production with HA (3-10 node AKS with autoscaling, zone-redundant PostgreSQL, multi-zone deployment).

## Resources
- AKS: 3-10 nodes, Standard_D8s_v3, multi-zone
- PostgreSQL: MemoryOptimized E4ds_v4, HA
- Zone redundancy: Enabled
- High availability: Full HA config

## Tasks
- Create production workspace
- Configure production.tfvars
- Enable HA features
- Test deployment

## Acceptance Criteria
- [ ] Workspace created
- [ ] tfvars configured
- [ ] Full HA enabled
- [ ] Successfully deployed

## Phase
Phase 4: Environments

## Dependencies
Requires all modules (#12, #13, #14)" \
  --label "infrastructure,terraform,environment,production" \
  --assignee "@me"

gh issue create --title "Create environment-specific tfvars files" \
  --body "## Description
Create .tfvars files for each environment with specific configurations like resource names, SKUs, regions, IP ranges, and tags.

## Files to Create
- \`terraform/environments/dev/terraform.tfvars\`
- \`terraform/environments/staging/terraform.tfvars\`
- \`terraform/environments/production/terraform.tfvars\`
- \`terraform.tfvars.example\` (template)

## Configuration Items
- Resource naming convention
- Azure regions
- SKU sizes
- IP ranges
- Tags
- Cost centers
- Environment-specific settings

## Acceptance Criteria
- [ ] All tfvars files created
- [ ] Example template created
- [ ] Values validated
- [ ] Documentation added

## Phase
Phase 4: Environments

## Dependencies
Requires environments configured (#16, #17, #18)" \
  --label "infrastructure,terraform,configuration" \
  --assignee "@me"

# Continue with remaining phases...
echo -e "${GREEN}Phase 5: Kubernetes Configuration${NC}"

gh issue create --title "Define Kubernetes namespaces with quotas" \
  --body "## Description
Create namespace manifests for applications (backend, frontend), infrastructure (ingress-nginx), and monitoring (elk-stack) with resource quotas and limits.

## Namespaces
- \`backend\` - Backend API
- \`frontend\` - Frontend app
- \`ingress-nginx\` - Ingress controller
- \`elk-stack\` - ELK monitoring
- \`kube-system\` - System (default)

## Resource Quotas
- CPU limits
- Memory limits
- Pod count limits
- PVC limits

## Acceptance Criteria
- [ ] All namespace manifests created
- [ ] Resource quotas defined
- [ ] Limit ranges configured
- [ ] Network policies ready
- [ ] Documentation complete

## Phase
Phase 5: Kubernetes Setup" \
  --label "kubernetes,configuration" \
  --assignee "@me"

gh issue create --title "Create backend Kubernetes manifests" \
  --body "## Description
Build Kubernetes deployment, service, HPA, configmap, and secret manifests for .NET Core backend with health checks, resource limits, and rolling update strategy.

## Manifests
- \`deployment.yml\` - Main deployment
- \`service.yml\` - ClusterIP service
- \`hpa.yml\` - Horizontal Pod Autoscaler
- \`configmap.yml\` - Configuration
- \`secrets.yml.example\` - Secrets template

## Configuration
- Replicas: 3 (production)
- Health checks: Liveness & readiness
- Rolling update: maxSurge 1, maxUnavailable 0
- Resources: 256Mi-512Mi memory, 250m-500m CPU

## Acceptance Criteria
- [ ] All manifests created
- [ ] Health checks configured
- [ ] HPA configured
- [ ] Resources optimized
- [ ] Comments added

## Phase
Phase 5: Kubernetes Setup

## Dependencies
Requires namespaces (#20)" \
  --label "kubernetes,backend,dotnet" \
  --assignee "@me"

gh issue create --title "Create frontend Kubernetes manifests" \
  --body "## Description
Build Kubernetes deployment, service, HPA, and configmap manifests for Next.js frontend with proper environment variables and CDN integration.

## Manifests
- \`deployment.yml\` - Main deployment
- \`service.yml\` - ClusterIP service
- \`hpa.yml\` - Horizontal Pod Autoscaler
- \`configmap.yml\` - Configuration

## Configuration
- Replicas: 2-5 (auto-scaling)
- Health checks: Liveness & readiness
- Rolling update: Zero-downtime
- Resources: 128Mi-256Mi memory, 100m-250m CPU

## Acceptance Criteria
- [ ] All manifests created
- [ ] Health checks configured
- [ ] HPA configured
- [ ] Environment variables set
- [ ] CDN integration ready

## Phase
Phase 5: Kubernetes Setup

## Dependencies
Requires namespaces (#20)" \
  --label "kubernetes,frontend,nextjs" \
  --assignee "@me"

gh issue create --title "Configure ingress with Application Gateway" \
  --body "## Description
Create ingress manifest with Application Gateway ingress controller, SSL/TLS termination, path-based routing, and rate limiting.

## Configuration
- Ingress controller: Application Gateway
- SSL/TLS: Let's Encrypt
- Path routing: /api → backend, / → frontend
- Rate limiting: Configured
- WAF: Enabled for production

## Acceptance Criteria
- [ ] Ingress manifest created
- [ ] SSL configured
- [ ] Path routing working
- [ ] Rate limiting applied
- [ ] WAF rules configured

## Phase
Phase 5: Kubernetes Setup

## Dependencies
Requires backend (#21) and frontend (#22) manifests" \
  --label "kubernetes,networking,ingress" \
  --assignee "@me"

gh issue create --title "Create ELK Stack Kubernetes manifests" \
  --body "## Description
Build StatefulSet manifests for Elasticsearch (3-node cluster), Deployment for Logstash and Kibana with persistent volumes, services, and resource limits.

## Components
- Elasticsearch: StatefulSet (3 nodes)
- Logstash: Deployment (2 replicas)
- Kibana: Deployment (1 replica)

## Configuration
- Persistent volumes: 100GB per ES node
- Resources: 2-4Gi memory per ES node
- Cluster formation: Zen discovery
- X-Pack: Security enabled

## Acceptance Criteria
- [ ] ES StatefulSet created
- [ ] Logstash deployment created
- [ ] Kibana deployment created
- [ ] Persistent volumes configured
- [ ] Services defined
- [ ] Resource limits set

## Phase
Phase 5: Kubernetes Setup

## Dependencies
Requires namespaces (#20)" \
  --label "kubernetes,elk,monitoring" \
  --assignee "@me"

# Phase 6: Ansible Playbooks
echo -e "${GREEN}Phase 6: Ansible Playbooks${NC}"

gh issue create --title "Create AKS configuration Ansible playbook" \
  --body "## Description
Build Ansible playbook to configure AKS post-provisioning including kubectl context setup, RBAC roles, pod security policies, and network policies.

## Tasks
- Configure kubectl context
- Set up RBAC roles
- Apply pod security policies
- Configure network policies
- Install cert-manager
- Install ingress controller

## Acceptance Criteria
- [ ] Playbook created
- [ ] All tasks implemented
- [ ] Idempotent execution
- [ ] Error handling added
- [ ] Documentation complete

## Phase
Phase 6: Ansible Automation

## Dependencies
Requires AKS deployed (#16-18)" \
  --label "ansible,kubernetes,automation" \
  --assignee "@me"

gh issue create --title "Create ELK deployment Ansible playbook" \
  --body "## Description
Build Ansible playbook to deploy ELK stack using Helm charts or manifests, configure Elasticsearch cluster settings, and setup index templates.

## Tasks
- Deploy Elasticsearch cluster
- Deploy Logstash with pipelines
- Deploy Kibana with dashboards
- Configure index templates
- Set up index lifecycle policies
- Configure retention policies

## Acceptance Criteria
- [ ] Playbook created
- [ ] ELK deployed successfully
- [ ] Cluster settings configured
- [ ] Index templates created
- [ ] Retention policies applied

## Phase
Phase 6: Ansible Automation

## Dependencies
Requires ELK manifests (#24)" \
  --label "ansible,elk,monitoring" \
  --assignee "@me"

gh issue create --title "Create monitoring setup Ansible playbook" \
  --body "## Description
Create Ansible playbook to configure monitoring dashboards in Kibana, set up alerting rules, and integrate with notification channels.

## Tasks
- Import Kibana dashboards
- Configure Elasticsearch alerts
- Set up notification channels (Slack, email)
- Configure alerting rules
- Set up uptime monitoring

## Acceptance Criteria
- [ ] Playbook created
- [ ] Dashboards imported
- [ ] Alerts configured
- [ ] Notifications working
- [ ] Documentation complete

## Phase
Phase 6: Ansible Automation

## Dependencies
Requires ELK deployed (#26)" \
  --label "ansible,monitoring,elk" \
  --assignee "@me"

gh issue create --title "Create application deployment Ansible playbook" \
  --body "## Description
Build Ansible playbook to automate application deployment including database migrations, secret rotation, and health checks.

## Tasks
- Run database migrations
- Deploy backend application
- Deploy frontend application
- Rotate secrets
- Verify health checks
- Run smoke tests

## Acceptance Criteria
- [ ] Playbook created
- [ ] Migrations automated
- [ ] Deployments working
- [ ] Health checks passing
- [ ] Smoke tests included

## Phase
Phase 6: Ansible Automation

## Dependencies
Requires K8s manifests (#21, #22)" \
  --label "ansible,deployment,automation" \
  --assignee "@me"

gh issue create --title "Create secrets management Ansible playbook" \
  --body "## Description
Create Ansible playbook to sync secrets from Azure Key Vault to Kubernetes using CSI driver and configure automatic rotation.

## Tasks
- Install Key Vault CSI driver
- Configure secret provider class
- Sync secrets to K8s
- Set up automatic rotation
- Test secret updates

## Acceptance Criteria
- [ ] Playbook created
- [ ] CSI driver installed
- [ ] Secrets syncing
- [ ] Rotation working
- [ ] Documentation complete

## Phase
Phase 6: Ansible Automation

## Dependencies
Requires Key Vault (#10) and AKS (#25)" \
  --label "ansible,security,secrets" \
  --assignee "@me"

# Phase 7: Application Dockerization
echo -e "${GREEN}Phase 7: Application Dockerization${NC}"

gh issue create --title "Create optimized .NET Core Dockerfile" \
  --body "## Description
Build optimized multi-stage Dockerfile for .NET Core API using SDK for build and runtime-only for final image, with non-root user and health check.

## Dockerfile Stages
1. Build stage: SDK for compilation
2. Runtime stage: ASP.NET runtime only
3. Non-root user for security
4. Health check endpoint

## Optimizations
- Multi-stage build
- Layer caching
- Minimal base image
- .dockerignore configured

## Acceptance Criteria
- [ ] Dockerfile created
- [ ] Multi-stage build working
- [ ] Image size < 200MB
- [ ] Non-root user configured
- [ ] Health check implemented
- [ ] .dockerignore added

## Phase
Phase 7: Dockerization" \
  --label "docker,backend,dotnet" \
  --assignee "@me"

gh issue create --title "Create optimized Next.js Dockerfile" \
  --body "## Description
Build optimized multi-stage Dockerfile for Next.js with npm install, build step, and nginx or standalone server for production with static asset caching.

## Dockerfile Stages
1. Dependencies: npm install
2. Build: Next.js build
3. Runtime: Standalone or nginx
4. Static assets: Optimized serving

## Optimizations
- Multi-stage build
- Layer caching
- Standalone output mode
- Static asset optimization

## Acceptance Criteria
- [ ] Dockerfile created
- [ ] Multi-stage build working
- [ ] Image size < 150MB
- [ ] Static assets optimized
- [ ] Build cache working
- [ ] .dockerignore added

## Phase
Phase 7: Dockerization" \
  --label "docker,frontend,nextjs" \
  --assignee "@me"

gh issue create --title "Create docker-compose for local development" \
  --body "## Description
Create docker-compose.yml for local development with backend, frontend, PostgreSQL, and ELK stack for testing before deploying to AKS.

## Services
- Backend: .NET Core API
- Frontend: Next.js
- PostgreSQL: Database
- Elasticsearch: Logging
- Logstash: Log processing
- Kibana: Visualization

## Acceptance Criteria
- [ ] docker-compose.yml created
- [ ] All services configured
- [ ] Networking working
- [ ] Volumes configured
- [ ] Health checks added
- [ ] README with instructions

## Phase
Phase 7: Dockerization

## Dependencies
Requires Dockerfiles (#30, #31)" \
  --label "docker,development,local" \
  --assignee "@me"

gh issue create --title "Optimize Docker images for production" \
  --body "## Description
Implement multi-stage builds, use alpine base images where possible, minimize layers, and implement .dockerignore to reduce image size and build time.

## Optimizations
- Multi-stage builds
- Alpine base images
- Layer minimization
- .dockerignore files
- Build cache optimization
- Security scanning

## Acceptance Criteria
- [ ] All images optimized
- [ ] Image sizes reduced >50%
- [ ] Build times improved
- [ ] .dockerignore comprehensive
- [ ] Security scan passing
- [ ] Documentation updated

## Phase
Phase 7: Dockerization

## Dependencies
Requires Dockerfiles (#30, #31)" \
  --label "docker,optimization,security" \
  --assignee "@me"

# Phase 8: CI/CD Pipeline
echo -e "${GREEN}Phase 8: CI/CD Pipeline${NC}"

gh issue create --title "Create Terraform CI/CD workflow" \
  --body "## Description
Build GitHub Actions workflow for terraform plan on PR, terraform apply on merge to main, with approval gates and state locking.

## Workflow Steps
- Terraform fmt check
- Terraform validate
- Terraform plan (on PR)
- Manual approval gate
- Terraform apply (on merge)
- State locking
- Slack notifications

## Acceptance Criteria
- [ ] Workflow file created
- [ ] Plan on PR working
- [ ] Apply on merge working
- [ ] State locking configured
- [ ] Approval gates set
- [ ] Notifications working

## Phase
Phase 8: CI/CD

## Dependencies
Requires Terraform modules (#7-14)" \
  --label "cicd,github-actions,terraform" \
  --assignee "@me"

gh issue create --title "Create backend deployment pipeline" \
  --body "## Description
Build GitHub Actions workflow to build .NET Core app, run tests, scan for vulnerabilities, build Docker image, push to ACR, and deploy to AKS.

## Workflow Steps
1. Checkout code
2. Run tests
3. Security scan
4. Build Docker image
5. Push to ACR
6. Deploy to AKS
7. Health check
8. Notify

## Environments
- Dev: Auto-deploy on develop branch
- Staging: Auto-deploy on staging branch
- Production: Manual approval required

## Acceptance Criteria
- [ ] Workflow created
- [ ] Tests running
- [ ] Security scanning working
- [ ] Image building and pushing
- [ ] AKS deployment working
- [ ] Environment gates configured

## Phase
Phase 8: CI/CD

## Dependencies
Requires Dockerfile (#30) and ACR (#9)" \
  --label "cicd,github-actions,backend" \
  --assignee "@me"

gh issue create --title "Create frontend deployment pipeline" \
  --body "## Description
Build GitHub Actions workflow to build Next.js app, run tests, optimize bundle, build Docker image, push to ACR, and deploy to AKS.

## Workflow Steps
1. Checkout code
2. Run tests
3. Build Next.js
4. Optimize bundle
5. Build Docker image
6. Push to ACR
7. Deploy to AKS
8. Health check

## Bundle Optimization
- Bundle analysis
- Tree shaking
- Code splitting
- Image optimization

## Acceptance Criteria
- [ ] Workflow created
- [ ] Tests running
- [ ] Bundle optimized
- [ ] Image building and pushing
- [ ] AKS deployment working
- [ ] Performance budget met

## Phase
Phase 8: CI/CD

## Dependencies
Requires Dockerfile (#31) and ACR (#9)" \
  --label "cicd,github-actions,frontend" \
  --assignee "@me"

gh issue create --title "Configure deployment approval gates" \
  --body "## Description
Set up approval requirements for staging and production deployments, environment-specific secrets, and rollback strategies.

## Approval Gates
- Staging: Auto-deploy with tests
- Production: Manual approval required
- Rollback: Automated on failure

## Environment Secrets
- Azure credentials per environment
- Database connection strings
- API keys
- Certificates

## Acceptance Criteria
- [ ] Approval gates configured
- [ ] Environment secrets set
- [ ] Rollback strategy implemented
- [ ] Documentation complete

## Phase
Phase 8: CI/CD

## Dependencies
Requires pipelines (#35, #36)" \
  --label "cicd,github-actions,security" \
  --assignee "@me"

gh issue create --title "Setup GitHub Secrets for Azure and ACR" \
  --body "## Description
Configure GitHub repository secrets for Azure credentials (service principal), ACR credentials, kubeconfig, and environment-specific variables.

## Secrets to Configure
- \`AZURE_CLIENT_ID\`
- \`AZURE_CLIENT_SECRET\`
- \`AZURE_TENANT_ID\`
- \`AZURE_SUBSCRIPTION_ID\`
- \`ACR_USERNAME\`
- \`ACR_PASSWORD\`
- \`KUBECONFIG_DEV\`
- \`KUBECONFIG_STAGING\`
- \`KUBECONFIG_PRODUCTION\`

## Security
- Rotate secrets regularly
- Use environment-specific secrets
- Document secret usage
- Set up expiration alerts

## Acceptance Criteria
- [ ] All secrets configured
- [ ] Environment separation
- [ ] Documentation complete
- [ ] Rotation schedule set

## Phase
Phase 8: CI/CD

## Dependencies
Requires Service Principal (#5)" \
  --label "cicd,security,github" \
  --assignee "@me"

# Phase 9: Security & Compliance
echo -e "${GREEN}Phase 9: Security & Compliance${NC}"

gh issue create --title "Configure Kubernetes RBAC and Azure AD" \
  --body "## Description
Configure Kubernetes RBAC roles and bindings, integrate with Azure AD for user authentication, and set up service accounts with least privilege.

## RBAC Roles
- Admin: Full cluster access
- Developer: Namespace-specific access
- Viewer: Read-only access
- CI/CD: Deployment access

## Azure AD Integration
- AAD pod identity
- RBAC integration
- MFA enforcement

## Acceptance Criteria
- [ ] RBAC roles defined
- [ ] Azure AD integrated
- [ ] Service accounts created
- [ ] Least privilege applied
- [ ] Documentation complete

## Phase
Phase 9: Security" \
  --label "security,kubernetes,rbac" \
  --assignee "@me"

gh issue create --title "Implement Kubernetes Network Policies" \
  --body "## Description
Create Kubernetes Network Policies to restrict pod-to-pod communication, deny all by default, and allow only required traffic flows.

## Network Policies
- Default deny all ingress/egress
- Allow backend → PostgreSQL
- Allow frontend → backend
- Allow pods → Kube DNS
- Allow ELK ingestion
- Allow egress to external APIs

## Acceptance Criteria
- [ ] All network policies created
- [ ] Default deny configured
- [ ] Required traffic allowed
- [ ] Policies tested
- [ ] Documentation complete

## Phase
Phase 9: Security

## Dependencies
Requires AKS deployed (#16-18)" \
  --label "security,kubernetes,networking" \
  --assignee "@me"

gh issue create --title "Setup SSL/TLS with cert-manager" \
  --body "## Description
Configure cert-manager with Let's Encrypt for automatic SSL certificate generation and renewal, or import certificates from Azure Key Vault.

## Configuration
- Install cert-manager
- Configure Let's Encrypt issuer
- Create certificate resources
- Set up auto-renewal
- Configure Azure Key Vault integration (optional)

## Domains
- API: api.example.com
- Frontend: example.com
- Kibana: kibana.example.com

## Acceptance Criteria
- [ ] cert-manager installed
- [ ] Let's Encrypt configured
- [ ] Certificates issued
- [ ] Auto-renewal working
- [ ] HTTPS enforced

## Phase
Phase 9: Security

## Dependencies
Requires ingress (#23)" \
  --label "security,kubernetes,certificates" \
  --assignee "@me"

gh issue create --title "Enable Azure Key Vault CSI driver for AKS" \
  --body "## Description
Install and configure Azure Key Vault CSI driver for AKS to mount secrets as volumes and enable automatic secret rotation.

## Configuration
- Install CSI driver
- Configure SecretProviderClass
- Mount secrets as volumes
- Enable auto-rotation
- Test secret updates

## Secrets to Sync
- Database credentials
- API keys
- Certificates
- Connection strings

## Acceptance Criteria
- [ ] CSI driver installed
- [ ] SecretProviderClass configured
- [ ] Secrets mounted successfully
- [ ] Auto-rotation working
- [ ] Documentation complete

## Phase
Phase 9: Security

## Dependencies
Requires Key Vault (#10) and AKS (#25)" \
  --label "security,kubernetes,secrets" \
  --assignee "@me"

gh issue create --title "Add container security scanning to CI/CD" \
  --body "## Description
Integrate Trivy or similar container scanning in CI/CD pipeline, implement image signing, and set up vulnerability reporting.

## Security Tools
- Trivy: Vulnerability scanning
- Cosign: Image signing
- Snyk: Dependency scanning

## CI/CD Integration
- Scan on every build
- Block high/critical vulnerabilities
- Generate vulnerability reports
- Sign production images

## Acceptance Criteria
- [ ] Trivy integrated
- [ ] Scanning on every build
- [ ] High/critical blocking
- [ ] Image signing implemented
- [ ] Reports generated

## Phase
Phase 9: Security

## Dependencies
Requires pipelines (#35, #36)" \
  --label "security,cicd,scanning" \
  --assignee "@me"

# Phase 10: Monitoring & Logging
echo -e "${GREEN}Phase 10: Monitoring & Logging${NC}"

gh issue create --title "Deploy production ELK Stack to AKS" \
  --body "## Description
Deploy production-grade ELK stack with 3-node Elasticsearch cluster, persistent volumes, resource limits, and high availability configuration.

## Configuration
- Elasticsearch: 3-node cluster
- Persistent volumes: 100GB per node
- Memory: 4Gi per ES node
- High availability: Multi-zone
- Backup: Snapshots to Azure Storage

## Acceptance Criteria
- [ ] ELK deployed to production
- [ ] 3-node cluster healthy
- [ ] Persistent volumes working
- [ ] HA configured
- [ ] Backups automated

## Phase
Phase 10: Monitoring

## Dependencies
Requires ELK manifests (#24) and playbook (#26)" \
  --label "monitoring,elk,production" \
  --assignee "@me"

gh issue create --title "Configure application log shipping to ELK" \
  --body "## Description
Configure .NET Core and Next.js applications to send structured logs to Logstash using appropriate appenders/libraries with correlation IDs.

## Backend (.NET Core)
- Serilog with Elasticsearch sink
- Structured logging
- Correlation IDs
- Log levels

## Frontend (Next.js)
- Winston or Pino
- Browser logging
- API logging
- Error tracking

## Acceptance Criteria
- [ ] Backend logging configured
- [ ] Frontend logging configured
- [ ] Structured logs working
- [ ] Correlation IDs present
- [ ] Logs appearing in Kibana

## Phase
Phase 10: Monitoring

## Dependencies
Requires ELK deployed (#44)" \
  --label "monitoring,logging,applications" \
  --assignee "@me"

gh issue create --title "Create Kibana dashboards and visualizations" \
  --body "## Description
Build Kibana dashboards for application metrics, error tracking, request analytics, and infrastructure monitoring with saved searches and visualizations.

## Dashboards
1. Application Overview
2. Error Tracking
3. Performance Metrics
4. Infrastructure Health
5. Security Events

## Visualizations
- Request rate
- Response times
- Error rates
- Resource usage
- Database queries

## Acceptance Criteria
- [ ] All dashboards created
- [ ] Visualizations configured
- [ ] Saved searches defined
- [ ] Alerts configured
- [ ] Documentation complete

## Phase
Phase 10: Monitoring

## Dependencies
Requires logs flowing (#45)" \
  --label "monitoring,elk,dashboards" \
  --assignee "@me"

gh issue create --title "Setup alerting rules in Elasticsearch" \
  --body "## Description
Configure Elasticsearch Watcher or ElastAlert for alerting on errors, performance degradation, and infrastructure issues with Slack/email notifications.

## Alert Rules
- High error rate (>1%)
- Slow response times (>2s)
- Pod restarts
- Disk space low
- Memory usage high
- Failed deployments

## Notifications
- Slack: Real-time alerts
- Email: Critical alerts
- PagerDuty: Production incidents

## Acceptance Criteria
- [ ] Alert rules configured
- [ ] Thresholds tuned
- [ ] Notifications working
- [ ] Alert testing complete
- [ ] Documentation added

## Phase
Phase 10: Monitoring

## Dependencies
Requires ELK deployed (#44)" \
  --label "monitoring,alerting,elk" \
  --assignee "@me"

gh issue create --title "Deploy Prometheus and Grafana for metrics" \
  --body "## Description
Deploy Prometheus and Grafana for metrics collection, configure service monitors for applications, and create Grafana dashboards for APM.

## Components
- Prometheus: Metrics collection
- Grafana: Visualization
- Node exporter: System metrics
- Kube-state-metrics: K8s metrics

## Metrics to Collect
- Pod CPU/Memory
- Request rate/latency
- Custom business metrics
- Database metrics

## Acceptance Criteria
- [ ] Prometheus deployed
- [ ] Grafana deployed
- [ ] Service monitors configured
- [ ] Dashboards created
- [ ] Alerts configured

## Phase
Phase 10: Monitoring

## Dependencies
Requires AKS deployed (#16-18)" \
  --label "monitoring,prometheus,grafana" \
  --assignee "@me"

# Phase 11: Testing & Validation
echo -e "${GREEN}Phase 11: Testing & Validation${NC}"

gh issue create --title "Validate complete dev environment deployment" \
  --body "## Description
Deploy complete stack to dev environment, verify all services are running, test API endpoints, frontend access, database connectivity, and ELK logging.

## Tests
- Infrastructure provisioned
- AKS cluster healthy
- PostgreSQL accessible
- Backend API responding
- Frontend loading
- ELK collecting logs
- Monitoring working

## Acceptance Criteria
- [ ] Full stack deployed
- [ ] All services healthy
- [ ] API endpoints tested
- [ ] Frontend accessible
- [ ] Database connected
- [ ] Logs in Kibana
- [ ] Metrics in Grafana

## Phase
Phase 11: Testing" \
  --label "testing,validation,dev" \
  --assignee "@me"

gh issue create --title "Test staging environment end-to-end" \
  --body "## Description
Deploy to staging, run integration tests, verify CI/CD pipelines, test environment promotion, and validate monitoring/alerting.

## Tests
- Full deployment via CI/CD
- Integration tests
- Security scanning
- Performance testing
- Monitoring validation
- Alert testing
- Rollback testing

## Acceptance Criteria
- [ ] Staging deployed via CI/CD
- [ ] Integration tests pass
- [ ] Security scans clean
- [ ] Performance acceptable
- [ ] Monitoring working
- [ ] Alerts triggering
- [ ] Rollback tested

## Phase
Phase 11: Testing

## Dependencies
Requires dev testing (#49)" \
  --label "testing,validation,staging" \
  --assignee "@me"

gh issue create --title "Test disaster recovery procedures" \
  --body "## Description
Test PostgreSQL backup/restore procedures, AKS cluster disaster recovery, and Elasticsearch snapshot/restore for data protection.

## Tests
- Database backup
- Database restore
- Point-in-time recovery
- AKS cluster backup
- Elasticsearch snapshots
- Full disaster recovery drill

## Acceptance Criteria
- [ ] Backup procedures documented
- [ ] Restore tested successfully
- [ ] RTO/RPO measured
- [ ] ES snapshots working
- [ ] DR runbook created
- [ ] Team trained

## Phase
Phase 11: Testing" \
  --label "testing,disaster-recovery,backup" \
  --assignee "@me"

gh issue create --title "Perform load testing on staging" \
  --body "## Description
Run load tests on staging using tools like k6 or JMeter, verify auto-scaling behavior, identify performance bottlenecks, and optimize resource limits.

## Load Testing
- Tool: k6 or JMeter
- Scenarios: Normal, peak, stress
- Metrics: RPS, latency, errors
- Duration: 30-60 minutes

## Tests
- Normal load (baseline)
- Peak load (2x normal)
- Stress test (until failure)
- Sustained load (endurance)

## Acceptance Criteria
- [ ] Load tests created
- [ ] Baseline established
- [ ] Auto-scaling verified
- [ ] Bottlenecks identified
- [ ] Optimizations applied
- [ ] Report generated

## Phase
Phase 11: Testing

## Dependencies
Requires staging deployed (#50)" \
  --label "testing,performance,load-testing" \
  --assignee "@me"

gh issue create --title "Validate monitoring and alerting coverage" \
  --body "## Description
Verify all logs are captured in ELK, metrics in Prometheus, alerts are triggering correctly, and dashboards show accurate data.

## Validation
- Log coverage: All apps logging
- Metric coverage: All services monitored
- Alert testing: Trigger all alerts
- Dashboard accuracy: Data validation
- Retention policies: Working

## Acceptance Criteria
- [ ] All logs captured
- [ ] All metrics collected
- [ ] Alerts triggering correctly
- [ ] Dashboards accurate
- [ ] Retention policies working
- [ ] No blind spots

## Phase
Phase 11: Testing

## Dependencies
Requires monitoring deployed (#44-48)" \
  --label "testing,monitoring,validation" \
  --assignee "@me"

# Phase 12: Documentation & Handoff
echo -e "${GREEN}Phase 12: Documentation & Handoff${NC}"

gh issue create --title "Create deployment documentation" \
  --body "## Description
Create comprehensive documentation for deploying infrastructure, applications, and handling common deployment scenarios with step-by-step guides.

## Documentation
- Infrastructure deployment guide
- Application deployment guide
- Environment setup guide
- Common scenarios
- Troubleshooting tips

## Acceptance Criteria
- [ ] All guides complete
- [ ] Step-by-step instructions
- [ ] Screenshots included
- [ ] Code examples added
- [ ] Tested by team member

## Phase
Phase 12: Documentation" \
  --label "documentation" \
  --assignee "@me"

gh issue create --title "Create operational runbook" \
  --body "## Description
Document troubleshooting procedures, common issues and solutions, incident response playbook, and escalation paths for operations team.

## Runbook Sections
- Common issues
- Troubleshooting procedures
- Incident response
- Escalation paths
- Contact information
- Emergency procedures

## Acceptance Criteria
- [ ] Runbook complete
- [ ] All scenarios covered
- [ ] Escalation paths defined
- [ ] Contact info current
- [ ] Tested with ops team

## Phase
Phase 12: Documentation" \
  --label "documentation,operations" \
  --assignee "@me"

gh issue create --title "Create architecture diagrams" \
  --body "## Description
Create architecture diagrams showing Azure resources, network topology, application flow, and data flow using tools like draw.io or PlantUML.

## Diagrams
1. High-level architecture
2. Network topology
3. Application flow
4. Data flow
5. Security architecture
6. Deployment pipeline

## Acceptance Criteria
- [ ] All diagrams created
- [ ] Export as PNG/SVG
- [ ] Include in documentation
- [ ] Review with team
- [ ] Version controlled

## Phase
Phase 12: Documentation" \
  --label "documentation,architecture" \
  --assignee "@me"

gh issue create --title "Create developer guide" \
  --body "## Description
Create developer guide explaining how to deploy applications, access logs, view metrics, and troubleshoot issues with examples and screenshots.

## Guide Contents
- Local development setup
- Deploying changes
- Accessing logs (Kibana)
- Viewing metrics (Grafana)
- Debugging applications
- Common developer tasks

## Acceptance Criteria
- [ ] Guide complete
- [ ] Examples included
- [ ] Screenshots added
- [ ] Tested by developer
- [ ] Feedback incorporated

## Phase
Phase 12: Documentation" \
  --label "documentation,developers" \
  --assignee "@me"

gh issue create --title "Prepare knowledge transfer materials" \
  --body "## Description
Create presentation deck, demo videos, and FAQ document for knowledge transfer to operations and development teams.

## Materials
- Presentation deck (PPT/PDF)
- Demo videos (deployment, monitoring)
- FAQ document
- Quick reference cards
- Training schedule

## Acceptance Criteria
- [ ] Presentation created
- [ ] Videos recorded
- [ ] FAQ compiled
- [ ] Reference cards printed
- [ ] Training sessions scheduled

## Phase
Phase 12: Documentation" \
  --label "documentation,training" \
  --assignee "@me"

echo -e "${BLUE}\n✨ Successfully created all GitHub issues!${NC}"
echo -e "${GREEN}Total issues created: 60${NC}"
echo -e "${BLUE}\nNext steps:${NC}"
echo "1. Visit: https://github.com/damnthonyy/azure-k8s-infrastructure/issues"
echo "2. Create a project board"
echo "3. Link all issues to the board"
echo "4. Start working on Phase 0 & 1 issues"
