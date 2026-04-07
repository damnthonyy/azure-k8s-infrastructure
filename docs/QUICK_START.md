# Quick Start Guide - Azure Setup

## 🚀 5-Minute Azure Credentials Setup

### Prerequisites
```bash
# Install required tools (macOS)
brew install azure-cli gh jq

# Verify installations
az --version
gh --version
jq --version
```

---

## Option 1: Automated Script (Recommended)

```bash
cd ~/Documents/azure-k8s-infrastructure

# Run the setup script
./scripts/setup-azure-credentials.sh

# Clean up after verification
rm sp-credentials.json
```

**That's it!** The script handles everything.

---

## Option 2: Manual Setup (Step-by-Step)

### Step 1: Azure Login
```bash
az login
```

### Step 2: Create Service Principal
```bash
SUBSCRIPTION_ID=$(az account show --query id -o tsv)

az ad sp create-for-rbac \
  --name "github-actions-azure-k8s" \
  --role contributor \
  --scopes /subscriptions/$SUBSCRIPTION_ID \
  --sdk-auth | tee sp-credentials.json
```

### Step 3: Set GitHub Secrets
```bash
cd ~/Documents/azure-k8s-infrastructure

# Set all secrets at once
gh secret set AZURE_CREDENTIALS < sp-credentials.json
gh secret set AZURE_CLIENT_ID --body "$(jq -r '.clientId' sp-credentials.json)"
gh secret set AZURE_CLIENT_SECRET --body "$(jq -r '.clientSecret' sp-credentials.json)"
gh secret set AZURE_SUBSCRIPTION_ID --body "$(jq -r '.subscriptionId' sp-credentials.json)"
gh secret set AZURE_TENANT_ID --body "$(jq -r '.tenantId' sp-credentials.json)"
```

### Step 4: Verify
```bash
# Check secrets are set
gh secret list

# Should show:
# AZURE_CLIENT_ID
# AZURE_CLIENT_SECRET
# AZURE_CREDENTIALS
# AZURE_SUBSCRIPTION_ID
# AZURE_TENANT_ID
```

### Step 5: Clean Up
```bash
# Delete the sensitive file
rm sp-credentials.json
```

### Step 6: Test
```bash
# Re-run the workflow
gh workflow run terraform-plan.yml

# Watch it run
gh run watch
```

---

## Option 3: Manual via GitHub Web UI

If you prefer not to use command line for GitHub Secrets:

1. **Create Service Principal** (terminal):
```bash
az login
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
az ad sp create-for-rbac \
  --name "github-actions-azure-k8s" \
  --role contributor \
  --scopes /subscriptions/$SUBSCRIPTION_ID \
  --sdk-auth
```

2. **Copy the JSON output** (looks like this):
```json
{
  "clientId": "12345678-1234-1234-1234-123456789abc",
  "clientSecret": "your-secret-value",
  "subscriptionId": "abcd-1234-5678-90ab-cdefghijk",
  "tenantId": "87654321-4321-4321-4321-fedcba987654",
  ...
}
```

3. **Go to GitHub** → Settings → Secrets and variables → Actions:
   https://github.com/damnthonyy/azure-k8s-infrastructure/settings/secrets/actions

4. **Add 5 secrets**:

   | Secret Name | Value |
   |-------------|-------|
   | `AZURE_CREDENTIALS` | Entire JSON (all of it) |
   | `AZURE_CLIENT_ID` | Just the `clientId` value |
   | `AZURE_CLIENT_SECRET` | Just the `clientSecret` value |
   | `AZURE_SUBSCRIPTION_ID` | Just the `subscriptionId` value |
   | `AZURE_TENANT_ID` | Just the `tenantId` value |

5. **Done!** Test by running a workflow on GitHub.

---

## Verification Checklist

- [ ] Azure CLI installed (`az --version`)
- [ ] GitHub CLI installed and authenticated (`gh auth status`)
- [ ] Logged into Azure (`az account show`)
- [ ] Service Principal created (JSON output received)
- [ ] All 5 GitHub Secrets set (`gh secret list` shows 5 secrets)
- [ ] Sensitive files deleted (`sp-credentials.json`)
- [ ] Workflows tested (re-run terraform-plan.yml)

---

## What This Enables

After setup, your GitHub Actions workflows can:

✅ Deploy infrastructure with Terraform  
✅ Create Azure resources (AKS, PostgreSQL, etc.)  
✅ Manage Kubernetes clusters  
✅ Automate deployments  

**Previously failing workflows will now pass:**
- `terraform-plan.yml` ✅
- `deploy-dev.yml` ✅ (when you push to develop)

---

## Next Steps

After credentials are configured:

1. **Merge PR #4** to develop
2. **Issue #5**: Setup Terraform backend (Azure Storage)
3. **Issue #6**: Verify all tool installations
4. **Phase 2**: Start building infrastructure modules

---

## Need Help?

**Full documentation**: See [AZURE_SETUP.md](./AZURE_SETUP.md) for detailed explanations, troubleshooting, and security best practices.

**Troubleshooting**:
- `az: command not found` → `brew install azure-cli`
- `gh: command not found` → `brew install gh && gh auth login`
- `jq: command not found` → `brew install jq` (optional)
- Workflow still failing → Verify secret names match exactly (case-sensitive)
