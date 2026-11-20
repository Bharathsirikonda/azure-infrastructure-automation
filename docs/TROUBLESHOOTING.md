# Troubleshooting Guide

This guide covers common issues encountered when managing Azure infrastructure with Terraform and Azure DevOps, along with actionable remediation steps.

---

## 1. Remote State Lock Collision (`Error acquiring state lock`)

### Symptom:
```
Error: Error acquiring the state lock
Lock Info:
  ID:        e4757c23-289b-4322-b91c-76b92f74136e
  Path:      stazinfrabootstrap/tfstate-dev/dev.terraform.tfstate
  Who:       runner@azure-devops-agent
```

### Cause:
A previous pipeline job was canceled, crashed, or timed out before Terraform could send the unlock command to Azure Blob Storage.

### Remediation:
1. Confirm that no active deployment job is running.
2. Run the Terraform unlock command:
   ```bash
   terraform force-unlock e4757c23-289b-4322-b91c-76b92f74136e
   ```
3. Alternatively, break the blob lease using Azure CLI:
   ```bash
   az storage blob lease break \
     --account-name "stazinfrabootstrapstate" \
     --container-name "tfstate-dev" \
     --blob-name "dev.terraform.tfstate"
   ```

---

## 2. Key Vault Name Collision or Soft-Deleted Conflict

### Symptom:
```
Error: A vault with the same name already exists in a soft-deleted state.
```

### Cause:
Azure Key Vault names are globally unique across all Azure tenants. When deleted, Key Vault remains in a soft-deleted state for 7–90 days unless purged.

### Remediation:
1. In `providers.tf`, ensure recovery is enabled:
   ```hcl
   features {
     key_vault {
       recover_soft_deleted_key_vaults = true
     }
   }
   ```
2. Or permanently purge the soft-deleted vault if not needed:
   ```bash
   az keyvault purge --name "kv-azinfra-dev-abcde" --location "eastus"
   ```

---

## 3. Azure RBAC Role Assignment Propagation Latency

### Symptom:
```
Error: Key Vault access denied when assigning secret permissions.
```

### Cause:
Azure Active Directory RBAC assignments can take 1–3 minutes to propagate across all regional endpoints.

### Remediation:
1. The Key Vault module includes explicit resource `depends_on = [azurerm_key_vault.this]` to ensure the vault is fully provisioned before secrets or role assignments are created.
2. If running locally, wait 60 seconds and re-run `terraform apply`.

---

## 4. App Service Key Vault Reference Showing Green Check / Red X

### Symptom:
In the Azure Portal under App Service > Configuration, a secret setting shows a red icon:
`Key Vault Reference: Failed to resolve`

### Cause:
1. The App Service Managed Identity has not yet been granted `Key Vault Secrets User` role on the Key Vault.
2. The Key Vault network firewall is blocking Azure App Service outbound IPs.

### Remediation:
1. Verify that the Managed Identity principal ID matches the role assignment:
   ```bash
   az role assignment list --assignee <APP_MANAGED_IDENTITY_PRINCIPAL_ID>
   ```
2. Ensure `bypass = "AzureServices"` is configured in `azurerm_key_vault.network_acls`.
3. Restart the App Service to trigger an immediate secret re-fetch:
   ```bash
   az webapp restart --name "app-azinfra-dev" --resource-group "rg-azinfra-dev-eastus"
   ```
