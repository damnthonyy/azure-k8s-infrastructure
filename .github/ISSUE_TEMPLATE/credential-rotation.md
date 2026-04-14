---
name: 🔄 Credential Rotation
about: Scheduled rotation of Azure Service Principal credentials
title: '[SECURITY] Rotate Azure Service Principal credentials - [DATE]'
labels: security, chore, azure
assignees: ''
---

## 🔐 Credential Rotation Required

This is a scheduled security task to rotate Azure Service Principal credentials.

**Due Date**: [DATE - 90 days from last rotation]  
**Last Rotation**: [DATE]  
**Service Principal**: github-actions-azure-k8s

---

## ✅ Rotation Checklist

### Pre-Rotation

- [ ] Verify no critical deployments are scheduled during rotation window
- [ ] Notify team of upcoming rotation
- [ ] Backup current credential metadata (not secrets!)

### Rotation Steps

- [ ] Run rotation script: `./scripts/rotate-azure-credentials.sh`
- [ ] Verify GitHub Secrets updated successfully
- [ ] Test authentication with Azure

### Testing

- [ ] Trigger CI workflow: `gh workflow run ci.yml`
- [ ] Verify workflow completes successfully
- [ ] Test Terraform plan: `gh workflow run terraform-plan.yml`
- [ ] Check for any authentication errors

### Post-Rotation

- [ ] Update Azure Key Vault (if used)
- [ ] Document rotation date in [CREDENTIAL_MANAGEMENT.md](../docs/CREDENTIAL_MANAGEMENT.md)
- [ ] Create next rotation issue (90 days from now)
- [ ] Close this issue

---

## 📝 Rotation Command

```bash
cd ~/Documents/azure-k8s-infrastructure
./scripts/rotate-azure-credentials.sh
```

---

## 🚨 In Case of Issues

If rotation fails or credentials don't work:

1. **Don't panic** - old credentials should still work with `--append` flag
2. Check Azure Portal → Azure Active Directory → App Registrations
3. Review script output for errors
4. See [troubleshooting guide](../docs/CREDENTIAL_MANAGEMENT.md#-troubleshooting)
5. Contact DevOps team if needed

---

## 📚 Documentation

- [Credential Management Guide](../docs/CREDENTIAL_MANAGEMENT.md)
- [Azure Setup Guide](../docs/AZURE_SETUP.md)
- [Quick Start](../docs/QUICK_START.md)

---

## 🗓️ Next Rotation

**Scheduled for**: [DATE + 90 days]  
**Create reminder issue on**: [DATE + 85 days]
