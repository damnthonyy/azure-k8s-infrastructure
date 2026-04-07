# Kubernetes Manifests

This directory contains Kubernetes manifests for deploying applications and infrastructure components.

## Structure

```
kubernetes/
├── backend/          # Backend API manifests
│   ├── deployment.yml
│   ├── service.yml
│   ├── hpa.yml
│   ├── configmap.yml
│   └── secrets.yml.example
├── frontend/         # Frontend app manifests
│   ├── deployment.yml
│   ├── service.yml
│   ├── hpa.yml
│   └── configmap.yml
├── ingress/         # Ingress controller configuration
│   └── ingress.yml
└── elk/             # ELK stack manifests
    ├── elasticsearch.yml
    ├── logstash.yml
    └── kibana.yml
```

## Namespaces

Applications are deployed to specific namespaces:
- `backend` - Backend API
- `frontend` - Frontend application
- `ingress-nginx` - Ingress controller
- `elk-stack` - ELK monitoring stack
- `kube-system` - System components

## Usage

### Apply Manifests

```bash
# Apply backend manifests
kubectl apply -f kubernetes/backend/

# Apply with namespace
kubectl apply -f kubernetes/backend/ -n backend
```

### Validate Manifests

```bash
# Dry run
kubectl apply -f kubernetes/backend/ --dry-run=client

# Validate with server
kubectl apply -f kubernetes/backend/ --dry-run=server
```

### Check Status

```bash
# Check deployments
kubectl get deployments -n backend

# Check pods
kubectl get pods -n backend

# Check services
kubectl get services -n backend
```

## Configuration

### ConfigMaps

Non-sensitive configuration stored in ConfigMaps:
- API endpoints
- Feature flags
- Environment settings

### Secrets

Sensitive data stored in Kubernetes Secrets:
- Database credentials
- API keys
- Certificates

**Note**: `secrets.yml` is gitignored. Use `secrets.yml.example` as template.

## Resource Management

All deployments include:
- **Resource Requests**: Minimum guaranteed resources
- **Resource Limits**: Maximum allowed resources
- **Health Checks**: Liveness and readiness probes
- **Auto-scaling**: HorizontalPodAutoscaler configuration

## Best Practices

1. **Namespaces** - Isolate applications
2. **Labels** - Consistent labeling for organization
3. **Annotations** - Document configurations
4. **Security** - Run as non-root user
5. **Probes** - Always include health checks
6. **Resources** - Define requests and limits

## Security

- Network Policies restrict pod-to-pod communication
- RBAC controls access to resources
- Pod Security Policies enforce security standards
- Secrets synced from Azure Key Vault via CSI driver
