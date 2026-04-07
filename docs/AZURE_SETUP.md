# Azure Credentials Setup Guide

This guide walks you through creating an Azure Service Principal and configuring GitHub Secrets for CI/CD automation.

---

## 🎯 Overview

To automate infrastructure deployment with Terraform and GitHub Actions, you need:
1. **Azure Service Principal** - Identity for GitHub Actions to authenticate with Azure
2. **GitHub Secrets** - Secure storage for Azure credentials
3. **Azure CLI** - Tool to create and manage Azure resources

---

## 📋 Prerequisites

### 1. Install Azure CLI

**macOS:**
```bash
brew update && brew install azure-cli
```

**Linux:**
```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

**Windows:**
```powershell
winget install -e --id Microsoft.AzureCLI
```

### 2. Verify Installation
```bash
az --version
```

---

## 🔐 Step 1: Login to Azure

```bash
# Login interactively (opens browser)
az login

# If you have multiple subscriptions, list them
az account list --output table

# Set the subscription you want to use
az account set --subscription "YOUR_SUBSCRIPTION_NAME_OR_ID"

# Verify current subscription
az account show
```

---

## 🏗️ Step 2: Create Azure Service Principal

### Option A: Quick Setup (Recommended for Getting Started)

Run this single command to create a Service Principal with Contributor role:

```bash
# Get your subscription ID
SUBSCRIPTION_ID=$(az account show --query id -o tsv)

# Create Service Principal with SDK auth format
az ad sp create-for-rbac \
  --name "github-actions-azure-k8s" \
  --role contributor \
  --scopes /subscriptions/$SUBSCRIPTION_ID \
  --sdk-auth
```

**Output Example:**
```json
{
  "clientId": "12345678-1234-1234-1234-123456789abc",
  "clientSecret": "super-secret-value-here",
  "subscriptionId": "abcdefgh-1234-5678-90ab-cdefghijklmn",
  "tenantId": "87654321-4321-4321-4321-fedcba987654",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}
```

⚠️ **IMPORTANT**: 
- **Save this entire JSON output** - you can't retrieve the `clientSecret` again!
- Copy it to a temporary file (we'll delete it after setup)
- This will be used for the `AZURE_CREDENTIALS` GitHub Secret

### Option B: Save to File (Recommended)

```bash
SUBSCRIPTION_ID=$(az account show --query id -o tsv)

# Create and save to file
az ad sp create-for-rbac \
  --name "github-actions-azure-k8s" \
  --role contributor \
  --scopes /subscriptions/$SUBSCRIPTION_ID \
  --sdk-auth | tee sp-credentials.json

echo "✅ Service Principal created and saved to sp-credentials.json"
echo "⚠️  Keep this file secure - don't commit to Git!"
```

---

## 🔒 Step 3: Configure GitHub Secrets

### Method A: Using GitHub Web UI (Easiest)

1. Go to: https://github.com/damnthonyy/azure-k8s-infrastructure/settings/secrets/actions
2. Click **New repository secret**
3. Add these 5 secrets:

#### Secret 1: AZURE_CREDENTIALS
- **Name**: `AZURE_CREDENTIALS`
- **Value**: Paste the **entire JSON output** from Step 2
```json
{
  "clientId": "...",
  "clientSecret": "...",
  "subscriptionId": "...",
  "tenantId": "...",
  ...
}
```

#### Secret 2: AZURE_CLIENT_ID
- **Name**: `AZURE_CLIENT_ID`
- **Value**: Copy just the `clientId` value (without quotes)
- Example: `12345678-1234-1234-1234-123456789abc`

#### Secret 3: AZURE_CLIENT_SECRET
- **Name**: `AZURE_CLIENT_SECRET`
- **Value**: Copy just the `clientSecret` value (without quotes)

#### Secret 4: AZURE_SUBSCRIPTION_ID
- **Name**: `AZURE_SUBSCRIPTION_ID`
- **Value**: Copy just the `subscriptionId` value (without quotes)

#### Secret 5: AZURE_TENANT_ID
- **Name**: `AZURE_TENANT_ID`
- **Value**: Copy just the `tenantId` value (without quotes)

### Method B: Using GitHub CLI (Faster)

```bash
cd ~/Documents/azure-k8s-infrastructure

# If you saved to sp-credentials.json in Step 2:

# Set the full JSON credentials
gh secret set AZURE_CREDENTIALS < sp-credentials.json

# Extract and set individual secrets
gh secret set AZURE_CLIENT_ID --body "$(jq -r '.clientId' sp-credentials.json)"
gh secret set AZURE_CLIENT_SECRET --body "$(jq -r '.clientSecret' sp-credentials.json)"
gh secret set AZURE_SUBSCRIPTION_ID --body "$(jq -r '.subscriptionId' sp-credentials.json)"
gh secret set AZURE_TENANT_ID --body "$(jq -r '.tenantId' sp-credentials.json)"

echo "✅ All GitHub Secrets configured!"
```

---

## ✅ Step 4: Verify Setup

### Check GitHub Secrets

```bash
cd ~/Documents/azure-k8s-infrastructure
gh secret list
```

You should see:
```
AZURE_CLIENT_ID         Updated 2026-04-07
AZURE_CLIENT_SECRET     Updated 2026-04-07
AZURE_CREDENTIALS       Updated 2026-04-07
AZURE_SUBSCRIPTION_ID   Updated 2026-04-07
AZURE_TENANT_ID         Updated 2026-04-07
```

### Test Service Principal Login

```bash
# Extract credentials if you have sp-credentials.json
CLIENT_ID=$(jq -r '.clientId' sp-credentials.json)
CLIENT_SECRET=$(jq -r '.clientSecret' sp-credentials.json)
TENANT_ID=$(jq -r '.tenantId' sp-credentials.json)

# Test login
az login --service-principal \
  --username "$CLIENT_ID" \
  --password "$CLIENT_SECRET" \
  --tenant "$TENANT_ID"

# Verify access
az account show
az group list -o table
```

### Test GitHub Actions Workflow

```bash
# Re-run the failing Terraform Plan workflow
gh run rerun $(gh run list --workflow=terraform-plan.yml --limit 1 --json databaseId -q '.[0].databaseId')

# Watch the workflow
gh run watch
```

---

## 🚀 Step 5: Clean Up Sensitive Files

After GitHub Secrets are configured:

```bash
# Delete the credentials file
rm sp-credentials.json

# Verify it's gone
ls -la | grep sp-credentials

echo "✅ Cleanup complete!"
```

---

## 🎯 Quick Start Script

Save this as `scripts/setup-azure-credentials.sh`:

```bash
#!/bin/bash
set -e

echo "🔐 Azure Service Principal Setup for GitHub Actions"
echo "===================================================="
echo ""

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo "❌ Azure CLI not installed"
    echo "Install: brew install azure-cli"
    exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "⚠️  jq not installed (recommended for automation)"
    echo "Install: brew install jq"
fi

# Step 1: Login to Azure
echo "📝 Step 1: Azure Login"
az login

# Step 2: Get subscription
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
SUBSCRIPTION_NAME=$(az account show --query name -o tsv)

echo ""
echo "✅ Using subscription: $SUBSCRIPTION_NAME"
echo "   ID: $SUBSCRIPTION_ID"
echo ""

# Step 3: Create Service Principal
echo "🏗️  Step 2: Creating Service Principal..."
SP_OUTPUT=$(az ad sp create-for-rbac \
  --name "github-actions-azure-k8s-$(date +%s)" \
  --role contributor \
  --scopes /subscriptions/$SUBSCRIPTION_ID \
  --sdk-auth)

echo "$SP_OUTPUT" > sp-credentials.json
echo "✅ Service Principal created and saved to sp-credentials.json"
echo ""

# Step 4: Configure GitHub Secrets
echo "🔒 Step 3: Configuring GitHub Secrets..."

if command -v jq &> /dev/null; then
    # Automated with jq
    gh secret set AZURE_CREDENTIALS < sp-credentials.json
    gh secret set AZURE_CLIENT_ID --body "$(echo "$SP_OUTPUT" | jq -r '.clientId')"
    gh secret set AZURE_CLIENT_SECRET --body "$(echo "$SP_OUTPUT" | jq -r '.clientSecret')"
    gh secret set AZURE_SUBSCRIPTION_ID --body "$(echo "$SP_OUTPUT" | jq -r '.subscriptionId')"
    gh secret set AZURE_TENANT_ID --body "$(echo "$SP_OUTPUT" | jq -r '.tenantId')"
    echo "✅ GitHub Secrets configured!"
else
    # Manual instructions
    echo "⚠️  Please manually configure GitHub Secrets:"
    echo ""
    echo "Go to: https://github.com/damnthonyy/azure-k8s-infrastructure/settings/secrets/actions"
    echo ""
    echo "Add these secrets:"
    echo "1. AZURE_CREDENTIALS (paste entire content of sp-credentials.json)"
    echo "2. AZURE_CLIENT_ID"
    echo "3. AZURE_CLIENT_SECRET"
    echo "4. AZURE_SUBSCRIPTION_ID"
    echo "5. AZURE_TENANT_ID"
    echo ""
    echo "Values are in: sp-credentials.json"
fi

echo ""
echo "📋 Verification:"
gh secret list

echo ""
echo "🎉 Setup Complete!"
echo ""
echo "Next steps:"
echo "1. Delete sp-credentials.json: rm sp-credentials.json"
echo "2. Test workflows: gh workflow run terraform-plan.yml"
echo "3. Continue with Issue #5: Terraform backend setup"
echo ""
echo "⚠️  IMPORTANT: Delete sp-credentials.json after verifying secrets!"
```

Make it executable:
```bash
chmod +x scripts/setup-azure-credentials.sh
```

Run it:
```bash
./scripts/setup-azure-credentials.sh
```

---

## 🔄 Complete Workflow Summary

### The 5-Minute Setup

```bash
# 1. Login
az login

# 2. Create Service Principal
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
az ad sp create-for-rbac \
  --name "github-actions-azure-k8s" \
  --role contributor \
  --scopes /subscriptions/$SUBSCRIPTION_ID \
  --sdk-auth | tee sp-credentials.json

# 3. Configure GitHub Secrets
cd ~/Documents/azure-k8s-infrastructure
gh secret set AZURE_CREDENTIALS < sp-credentials.json
gh secret set AZURE_CLIENT_ID --body "$(jq -r '.clientId' sp-credentials.json)"
gh secret set AZURE_CLIENT_SECRET --body "$(jq -r '.clientSecret' sp-credentials.json)"
gh secret set AZURE_SUBSCRIPTION_ID --body "$(jq -r '.subscriptionId' sp-credentials.json)"
gh secret set AZURE_TENANT_ID --body "$(jq -r '.tenantId' sp-credentials.json)"

# 4. Verify
gh secret list

# 5. Clean up
rm sp-credentials.json

# 6. Test
gh workflow run terraform-plan.yml
gh run watch
```

---

## 🐛 Troubleshooting

### Error: "insufficient privileges"

You need **Application Administrator** role in Azure AD to create Service Principals.

**Solution**: Ask your Azure Admin to either:
1. Grant you the role
2. Create the Service Principal for you and provide the credentials

### Error: "az: command not found"

**Solution**: Install Azure CLI
```bash
brew install azure-cli
```

### Error: "gh: command not found"

**Solution**: Install GitHub CLI
```bash
brew install gh
gh auth login
```

### Error: "jq: command not found"

**Solution**: Install jq (JSON processor)
```bash
brew install jq
```

### Workflow Still Failing

1. **Verify secrets are set**:
```bash
gh secret list
```

2. **Check secret names match** (case-sensitive):
   - `AZURE_CREDENTIALS` (not `Azure_Credentials`)
   - `AZURE_CLIENT_ID` (not `AZURE_CLIENTID`)

3. **Re-run workflow**:
```bash
gh run rerun $(gh run list --limit 1 --json databaseId -q '.[0].databaseId')
```

---

## 📚 What's Next?

After Azure credentials are configured:

✅ **Terraform Plan workflows will pass**
✅ **Ready to deploy infrastructure**

**Next Issues:**
- **Issue #5**: Setup Terraform backend (Azure Storage)
- **Issue #6**: Document tool installations
- **Phase 2**: Build AKS Terraform modules

---

## 🔒 Security Notes

1. **Never commit** `sp-credentials.json` to Git (already in `.gitignore`)
2. **Rotate credentials** every 90 days
3. **Use separate Service Principals** for prod (recommended)
4. **Enable Azure AD audit logs** to monitor Service Principal usage
5. **Use Azure Key Vault** for additional secrets (database passwords, API keys)

---

## 📖 References

- [Azure Service Principal Docs](https://learn.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal)
- [GitHub Encrypted Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [Azure Login Action](https://github.com/Azure/login)
