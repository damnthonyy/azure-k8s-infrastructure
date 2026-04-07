# Helper Scripts

This directory contains helper scripts for infrastructure management and deployment.

## Available Scripts

### `create-github-issues.sh`
Creates all GitHub issues for the project roadmap.

```bash
./scripts/create-github-issues.sh
```

### `init-terraform.sh` (Coming Soon)
Initializes Terraform backend and workspaces.

```bash
./scripts/init-terraform.sh
```

### `setup-kubectl.sh` (Coming Soon)
Configures kubectl context for AKS clusters.

```bash
./scripts/setup-kubectl.sh [environment]
# Example: ./scripts/setup-kubectl.sh dev
```

### `generate-secrets.sh` (Coming Soon)
Generates and stores secrets in Azure Key Vault.

```bash
./scripts/generate-secrets.sh [environment]
```

## Usage

All scripts should be run from the repository root:

```bash
cd ~/Documents/azure-k8s-infrastructure
./scripts/[script-name].sh
```

## Security

Scripts that handle sensitive data:
- Never commit credentials
- Use Azure Key Vault for storage
- Log operations for audit trail
- Validate inputs before execution

## Contributing

When adding new scripts:
1. Make them executable: `chmod +x scripts/script-name.sh`
2. Add error handling (`set -e`)
3. Add help text (`--help` flag)
4. Document in this README
5. Add comments explaining complex logic
