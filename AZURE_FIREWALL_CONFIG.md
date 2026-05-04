# Azure Firewall Configuration

## Strategy: Production Only

This deployment configures Azure Firewall for **production environment only** to optimize costs while maintaining security.

### Deployment Plan

| Environment | Firewall | Egress Routing | Notes |
|---|---|---|---|
| **dev** | ❌ Disabled | Direct internet | Cost optimization for development |
| **staging** | ❌ Disabled | Direct internet | Testing without firewall overhead |
| **prod** | ✅ Enabled | All traffic via AFW | Production-grade egress control |

### Production Configuration

**Enable in `terraform/environments/prod/terraform.tfvars`:**
```hcl
networking_enable_azure_firewall             = true
networking_route_all_egress_through_firewall = true
```

### What This Does

1. **Firewall Deployment**
   - Creates Azure Firewall in the AzureFirewallSubnet (10.20.254.0/26)
   - Assigns a public static IP for egress
   - Uses Standard tier for cost optimization

2. **Egress Routing**
   - All subnets (AKS, AppGW, PostgreSQL, ELK) route 0.0.0.0/0 through the firewall
   - Firewall private IP is auto-injected into route tables

3. **Network Architecture**
   ```
   [AKS/AppGW/PostgreSQL/ELK Subnets]
                ↓
   [Route Tables] (0.0.0.0/0 → Firewall)
                ↓
   [Azure Firewall] (AzureFirewallSubnet)
                ↓
   [Internet/Azure Services]
   ```

### Firewall Rules

Currently, **no application firewall rules are configured**. 
- Firewall acts as NAT gateway for outbound connections
- Next step: Add Network & Application rules based on actual traffic flows

### Cost Estimate

- Azure Firewall (Standard): ~$1.25/hour (~$30/month)
- Public IP: ~$3/month
- Data processing: ~$0.016/GB

### Security Notes

- Threat Intelligence: Alert mode (detects suspicious traffic)
- Default deny egress once rules are applied
- All Azure regions benefit from Azure Firewall protection
