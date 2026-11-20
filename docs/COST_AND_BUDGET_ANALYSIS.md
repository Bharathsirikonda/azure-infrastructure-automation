# Azure Cost & Budget Analysis

This document provides a realistic cost breakdown, architectural sizing rationale, and cost optimization recommendations for the infrastructure provisioned in this project.

---

## 1. Estimated Cost Breakdown (Monthly & Annual)

### Development Environment (Cost-Optimized)
Designed for functional testing, automated validation, and developer experimentation.

| Resource | Sizing / SKU | Units | Monthly Est. (USD) | Annual Est. (USD) |
|---|---|---|---|---|
| **App Service Plan** | B1 Basic (1 Core, 1.75 GB RAM) | 1 | $12.41 | $148.92 |
| **Linux Web App** | Included with Plan | 1 | $0.00 | $0.00 |
| **Azure Key Vault** | Standard Tier (< 10,000 ops) | 1 | $0.03 | $0.36 |
| **Storage Account** | Standard LRS (~10 GB + Read/Write ops) | 1 | $0.22 | $2.64 |
| **Remote State Backend** | Shared Bootstrap Storage Account | Shared | $0.05 | $0.60 |
| **Total Development** | | | **~$12.71 / mo** | **~$152.52 / yr** |

---

### Production Environment (High Availability & Resilience)
Designed for customer-facing workloads, staging slots, custom domains, and auto-scaling.

| Resource | Sizing / SKU | Units | Monthly Est. (USD) | Annual Est. (USD) |
|---|---|---|---|---|
| **App Service Plan** | S1 Standard (1 Core, 1.75 GB RAM, Auto-scale, Staging Slots) | 1 | $73.00 | $876.00 |
| **Linux Web App** | Included with Plan | 1 | $0.00 | $0.00 |
| **Azure Key Vault** | Standard Tier (~50,000 ops + 90-day retention) | 1 | $0.15 | $1.80 |
| **Storage Account** | Standard GRS Geo-Redundant (~50 GB + Ops) | 1 | $2.10 | $25.20 |
| **Remote State Backend** | Shared Bootstrap Storage Account | Shared | $0.12 | $1.44 |
| **Total Production** | | | **~$75.37 / mo** | **~$904.44 / yr** |

---

## 2. FinOps Optimization Strategies

1. **Free Tier Sizing for Local Sandbox:**
   Developers can toggle `app_service_sku = "F1"` in `environments/dev/dev.tfvars` for non-critical testing, reducing compute costs to $0.00/month.
2. **Azure Reserved Instances (RI):**
   Committing to a 1-year or 3-year Azure Reserved Instance on App Service Plans yields up to **38%–55% discounts** compared to Pay-As-You-Go pricing.
3. **Automated Budget Alerts:**
   Establish an Azure Consumption Budget with action groups:
   ```bash
   az consumption budget create \
     --budget-name "azinfra-monthly-budget" \
     --amount 100 \
     --time-grain monthly \
     --start-date "2026-11-01" \
     --end-date "2027-11-01" \
     --resource-group "rg-azinfra-dev-eastus"
   ```
4. **Clean Deletion Verification:**
   Before running any manual `terraform apply`, verify expected resource counts with `terraform plan` to prevent accidental orphaned instances.
