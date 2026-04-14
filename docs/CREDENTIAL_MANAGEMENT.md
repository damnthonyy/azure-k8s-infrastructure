# Azure Service Principal - Credential Management

This document explains how to manage Azure Service Principal credentials for this project.

---

## 📋 Overview

The project uses an **Azure Service Principal** to authenticate GitHub Actions workflows with Azure. This allows automated deployment of infrastructure and applications.

**Security principle**: Credentials should be rotated every 90 days.

---

## 🔐 Initial Setup

If you haven't set up credentials yet, see:
- **Quick Start**: [docs/QUICK_START.md](./QUICK_START.md)
- **Full Guide**: [docs/AZURE_SETUP.md](./AZURE_SETUP.md)

---

## 🔄 Credential Rotation

### When to Rotate

- **Every 90 days** (recommended)
- **Immediately** if credentials are compromised
- **Before** a team member with access leaves the project

### Automated Rotation (Recommended)

```bash
cd ~/Documents/azure-k8s-infrastructure

# Run the rotation script
./scripts/rotate-azure-credentials.sh

# Follow the prompts
```

The script will:
1. Find your Service Principal
2. Generate new credentials
3. Update all GitHub Secrets
4. Clean up temporary files

### Manual Rotation

```bash
# 1. Login to Azure
az login

# 2. List Service Principals to find yours
az ad sp list --query "[].{name:displayName, appId:appId}" -o table

# 3. Reset credentials (replace APP_ID with yours)
SP_APP_ID="your-app-id-here"
az ad sp credential reset --id "$SP_APP_ID" --append

# 4. Update GitHub Secrets with new values (see output from step 3)
gh secret set AZURE_CLIENT_SECRET --body "NEW_SECRET_HERE"
gh secret set AZURE_CREDENTIALS --body '{...}'  # Full JSON
```

---

## 🗓️ Rotation Schedule

| Action | Frequency | Responsible | Next Due |
|--------|-----------|-------------|----------|
| Rotate Service Principal secret | 90 days | DevOps Lead | Set after first rotation |
| Review access permissions | 30 days | Security Team | - |
| Audit secret usage | Weekly | Automated (Azure Monitor) | - |

**Set a calendar reminder** for 85 days after rotation to prepare for the next one.

---

## 📍 Where Credentials are Stored

### 1. GitHub Secrets (Primary - for CI/CD)

Location: https://github.com/damnthonyy/azure-k8s-infrastructure/settings/secrets/actions

Secrets stored:
- `AZURE_CREDENTIALS` - Full JSON credentials
- `AZURE_CLIENT_ID` - Service Principal App ID
- `AZURE_CLIENT_SECRET` - Service Principal password
- `AZURE_SUBSCRIPTION_ID` - Azure subscription ID
- `AZURE_TENANT_ID` - Azure AD tenant ID

**Access**: Repository administrators only

### 2. Azure Key Vault (Optional - for team access)

If you want team members to access credentials:

```bash
# Create Key Vault
az keyvault create \
  --name kv-azure-k8s-prod \
  --resource-group rg-security \
  --location eastus

# Store secrets
az keyvault secret set --vault-name kv-azure-k8s-prod \
  --name azure-client-id --value "YOUR_CLIENT_ID"

az keyvault secret set --vault-name kv-azure-k8s-prod \
  --name azure-client-secret --value "YOUR_CLIENT_SECRET"

# Grant access to team members
az keyvault set-policy \
  --name kv-azure-k8s-prod \
  --upn user@example.com \
  --secret-permissions get list
```

### 3. Local Development (Never!)

❌ **NEVER** store credentials in:
- `.env` files (even if in `.gitignore`)
- Code files
- Configuration files committed to Git
- Unencrypted text files

---

## 🔍 Credential Audit

### Check Current Service Principal

```bash
# List all Service Principals you own
az ad sp list --show-mine -o table

# Get details about specific SP
az ad sp show --id "APP_ID" -o yaml

# Check role assignments
az role assignment list --assignee "APP_ID" -o table
```

### Verify GitHub Secrets

```bash
cd ~/Documents/azure-k8s-infrastructure

# List all secrets (values are hidden)
gh secret list

# Should show:
# AZURE_CLIENT_ID         Updated YYYY-MM-DD
# AZURE_CLIENT_SECRET     Updated YYYY-MM-DD
# AZURE_CREDENTIALS       Updated YYYY-MM-DD
# AZURE_SUBSCRIPTION_ID   Updated YYYY-MM-DD
# AZURE_TENANT_ID         Updated YYYY-MM-DD
```

### Test Credentials

```bash
# Test Service Principal can authenticate
az login --service-principal \
  --username "$AZURE_CLIENT_ID" \
  --password "$AZURE_CLIENT_SECRET" \
  --tenant "$AZURE_TENANT_ID"

# Verify permissions
az account show
az group list -o table
```

---

## 🚨 Credential Compromise Response

If credentials are compromised or suspected to be compromised:

### Immediate Actions (within 1 hour)

```bash
# 1. Disable the Service Principal immediately
az ad sp update --id "APP_ID" --set accountEnabled=false

# 2. Revoke all tokens
az ad sp credential reset --id "APP_ID" --append

# 3. Review Azure Activity Logs for suspicious activity
az monitor activity-log list \
  --start-time "2026-04-07T00:00:00Z" \
  --max-records 50 \
  --query "[?caller=='APP_ID']"
```

### Follow-up Actions (within 24 hours)

```bash
# 1. Create new Service Principal
az ad sp create-for-rbac \
  --name "github-actions-azure-k8s-new-$(date +%s)" \
  --role contributor \
  --scopes /subscriptions/$(az account show --query id -o tsv) \
  --sdk-auth

# 2. Update GitHub Secrets with new credentials
# (Use the Azure Setup guide steps above to recreate credentials if needed)

# 3. Test workflows
gh workflow run ci.yml
gh run watch

# 4. Delete old Service Principal
az ad sp delete --id "OLD_APP_ID"

# 5. Document incident
# Create post-mortem: docs/incidents/YYYY-MM-DD-credential-compromise.md
```

### Notification

Who to notify:
- [ ] Project Owner
- [ ] DevOps Team
- [ ] Security Team
- [ ] Team members with Azure access

---

## 🔒 Security Best Practices

### 1. Principle of Least Privilege

Instead of `Contributor` role on entire subscription, use scoped permissions:

```bash
# Create resource group for project
az group create --name rg-azure-k8s-prod --location eastus

# Assign role only to specific resource group
az role assignment create \
  --assignee "$SP_APP_ID" \
  --role "Contributor" \
  --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/rg-azure-k8s-prod"
```

### 2. Enable Audit Logging

```bash
# Enable diagnostic settings for Service Principal activity
az monitor diagnostic-settings create \
  --resource "/subscriptions/$SUBSCRIPTION_ID" \
  --name "sp-audit-logs" \
  --logs '[{"category": "Administrative", "enabled": true}]' \
  --workspace "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/rg-monitoring/providers/Microsoft.OperationalInsights/workspaces/log-analytics-workspace"
```

### 3. Set Up Alerts

Create Azure Monitor alerts for:
- Service Principal authentication failures
- Unusual API calls
- Permission changes
- Secret access from unknown locations

### 4. Use Managed Identities (When Possible)

For resources running in Azure (like VMs or Azure Functions), use **Managed Identities** instead of Service Principals - no credential management needed!

---

## 📚 Reference Commands

### Service Principal Management

```bash
# Create
az ad sp create-for-rbac --name "NAME" --role "ROLE" --scopes "SCOPE"

# List
az ad sp list --show-mine -o table

# Get details
az ad sp show --id "APP_ID"

# Reset password
az ad sp credential reset --id "APP_ID"

# Delete
az ad sp delete --id "APP_ID"

# Update
az ad sp update --id "APP_ID" --set KEY=VALUE
```

### GitHub Secrets Management

```bash
# List secrets
gh secret list

# Set secret
gh secret set SECRET_NAME --body "VALUE"
gh secret set SECRET_NAME < file.json

# Delete secret
gh secret delete SECRET_NAME
```

---

## 🆘 Troubleshooting

### "Insufficient privileges to complete the operation"

**Cause**: You don't have permission to create Service Principals.

**Solution**: Ask Azure Administrator to grant you "Application Administrator" role or create the SP for you.

### "The credentials in GitHub Secrets have expired"

**Cause**: Azure AD credentials can expire (if set with expiration).

**Solution**: Run the rotation script: `./scripts/rotate-azure-credentials.sh`

### "AADSTS700016: Application not found"

**Cause**: Service Principal was deleted or doesn't exist.

**Solution**: Create a new Service Principal using the setup script.

---

## 📖 Additional Resources

- [Azure AD Service Principals](https://learn.microsoft.com/en-us/azure/active-directory/develop/app-objects-and-service-principals)
- [Azure RBAC Best Practices](https://learn.microsoft.com/en-us/azure/role-based-access-control/best-practices)
- [GitHub Encrypted Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [Credential Rotation Best Practices](https://learn.microsoft.com/en-us/security/privileged-access-workstations/privileged-access-security-levels)

---

## ✅ Checklist for New Team Members

When onboarding someone who needs Azure access:

- [ ] Create individual Azure AD account
- [ ] Grant appropriate RBAC role (don't share Service Principal!)
- [ ] Provide access to Azure Key Vault (if used)
- [ ] Add to GitHub repository with appropriate permissions
- [ ] Review this document together
- [ ] Test their access with read-only operations first
- [ ] Document their access in team roster

---

**Last Updated**: 2026-04-07  
**Next Scheduled Rotation**: [Set date after first setup]  
**Responsible**: DevOps Team
