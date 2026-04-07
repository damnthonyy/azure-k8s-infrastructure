#!/bin/bash
set -e

echo "🔐 Azure Service Principal Setup for GitHub Actions"
echo "===================================================="
echo ""

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo "❌ Azure CLI not installed"
    echo "📦 Install with: brew install azure-cli"
    exit 1
fi

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI not installed"
    echo "📦 Install with: brew install gh"
    exit 1
fi

# Check if jq is installed (optional but recommended)
if ! command -v jq &> /dev/null; then
    echo "⚠️  jq not installed (recommended for automation)"
    echo "📦 Install with: brew install jq"
    echo ""
fi

# Step 1: Login to Azure
echo "📝 Step 1: Azure Login"
echo "Opening browser for authentication..."
az login

# Step 2: Get subscription
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
SUBSCRIPTION_NAME=$(az account show --query name -o tsv)

echo ""
echo "✅ Using subscription: $SUBSCRIPTION_NAME"
echo "   ID: $SUBSCRIPTION_ID"
echo ""

read -p "Is this the correct subscription? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Aborted. List subscriptions with: az account list --output table"
    echo "   Set subscription with: az account set --subscription 'NAME_OR_ID'"
    exit 1
fi

# Step 3: Create Service Principal
echo ""
echo "🏗️  Step 2: Creating Service Principal..."
SP_NAME="github-actions-azure-k8s-$(date +%s)"

SP_OUTPUT=$(az ad sp create-for-rbac \
  --name "$SP_NAME" \
  --role contributor \
  --scopes /subscriptions/$SUBSCRIPTION_ID \
  --sdk-auth)

echo "$SP_OUTPUT" > sp-credentials.json
echo "✅ Service Principal '$SP_NAME' created"
echo "✅ Credentials saved to sp-credentials.json"
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
    echo "✅ GitHub Secrets configured successfully!"
else
    # Manual with GitHub CLI (without jq)
    echo "⚠️  Setting secrets without jq (manual values needed)..."
    gh secret set AZURE_CREDENTIALS < sp-credentials.json
    echo ""
    echo "⚠️  Please manually set these secrets from sp-credentials.json:"
    echo "   - AZURE_CLIENT_ID"
    echo "   - AZURE_CLIENT_SECRET"
    echo "   - AZURE_SUBSCRIPTION_ID"
    echo "   - AZURE_TENANT_ID"
    echo ""
    echo "Go to: https://github.com/damnthonyy/azure-k8s-infrastructure/settings/secrets/actions"
    cat sp-credentials.json
fi

echo ""
echo "📋 Verification - GitHub Secrets:"
gh secret list

echo ""
echo "🎉 Setup Complete!"
echo ""
echo "⚠️  IMPORTANT NEXT STEPS:"
echo "1. Verify secrets are correct: gh secret list"
echo "2. Delete credentials file: rm sp-credentials.json"
echo "3. Test workflow: gh workflow run terraform-plan.yml"
echo ""
echo "🔒 Security reminder: sp-credentials.json contains sensitive data!"
echo "   Delete it after verifying GitHub Secrets are set correctly."
