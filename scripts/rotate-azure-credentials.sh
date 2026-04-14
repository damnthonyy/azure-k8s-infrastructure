#!/bin/bash
set -e

echo "🔄 Azure Service Principal Credential Rotation"
echo "==============================================="
echo ""

# Check prerequisites
if ! command -v az &> /dev/null; then
    echo "❌ Azure CLI not installed"
    exit 1
fi

if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI not installed"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "❌ jq not installed (required for credential rotation)"
    echo "📦 Install with: brew install jq"
    exit 1
fi

# Get Service Principal name
DEFAULT_SP_NAME=$(az ad sp list --display-name "github-actions-azure-k8s*" --query '[-1].displayName' -o tsv || true)
if [ -z "$DEFAULT_SP_NAME" ]; then
    DEFAULT_SP_NAME="github-actions-azure-k8s"
fi

read -p "Enter Service Principal name (default: $DEFAULT_SP_NAME): " SP_NAME
SP_NAME=${SP_NAME:-$DEFAULT_SP_NAME}

echo ""
echo "🔍 Finding Service Principal: $SP_NAME"

# Get Service Principal App ID
SP_APP_ID=$(az ad sp list --display-name "$SP_NAME" --query "[0].appId" -o tsv)

if [ -z "$SP_APP_ID" ]; then
    echo "❌ Service Principal '$SP_NAME' not found"
    echo "List all Service Principals: az ad sp list --query '[].displayName' -o tsv"
    exit 1
fi

echo "✅ Found Service Principal"
echo "   Name: $SP_NAME"
echo "   App ID: $SP_APP_ID"
echo ""

# Confirm rotation
read -p "⚠️  This will reset the client secret. Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Aborted"
    exit 1
fi

# Reset credentials
echo ""
echo "🔄 Rotating credentials..."

NEW_CREDS=$(az ad sp credential reset \
  --id "$SP_APP_ID" \
  --append \
  --query "{clientId: appId, clientSecret: password, tenantId: tenant}" \
  -o json)

SUBSCRIPTION_ID=$(az account show --query id -o tsv)

# Create full credentials JSON
FULL_CREDS=$(echo "$NEW_CREDS" | jq --arg sub "$SUBSCRIPTION_ID" '. + {
  subscriptionId: $sub,
  activeDirectoryEndpointUrl: "https://login.microsoftonline.com",
  resourceManagerEndpointUrl: "https://management.azure.com/",
  activeDirectoryGraphResourceId: "https://graph.windows.net/",
  sqlManagementEndpointUrl: "https://management.core.windows.net:8443/",
  galleryEndpointUrl: "https://gallery.azure.com/",
  managementEndpointUrl: "https://management.core.windows.net/"
}')

echo "✅ Credentials rotated successfully"
echo ""

# Update GitHub Secrets
echo "🔒 Updating GitHub Secrets..."

gh secret set AZURE_CREDENTIALS --body "$FULL_CREDS"
gh secret set AZURE_CLIENT_ID --body "$(echo "$FULL_CREDS" | jq -r '.clientId')"
gh secret set AZURE_CLIENT_SECRET --body "$(echo "$FULL_CREDS" | jq -r '.clientSecret')"
gh secret set AZURE_TENANT_ID --body "$(echo "$FULL_CREDS" | jq -r '.tenantId')"
gh secret set AZURE_SUBSCRIPTION_ID --body "$(echo "$FULL_CREDS" | jq -r '.subscriptionId')"

echo "✅ GitHub Secrets updated"
echo ""
echo "🎉 Credential rotation complete!"
echo ""
echo "📋 Next steps:"
echo "1. Test workflows: gh workflow run ci.yml"
echo "2. Update Azure Key Vault (if used)"
echo "3. Document rotation date in team calendar"
echo "4. Schedule next rotation in 90 days"
