# Architecture Overview

This project implements an enterprise Infrastructure as Code (IaC) foundation on Microsoft Azure using Terraform and automated Azure DevOps CI/CD pipelines.

---

## 1. High-Level System Architecture

```mermaid
flowchart TD
    subgraph CI_CD["Azure DevOps CI/CD Engine"]
        AD_VAL["1. Validate & Format Check"] --> AD_PDEV["2. Plan Dev"]
        AD_PDEV --> AD_ADEV["3. Apply Dev (Automated)"]
        AD_ADEV --> AD_PPROD["4. Plan Prod"]
        AD_PPROD --> AD_GATE{"5. Approval Gate (Manual Review)"}
        AD_GATE -->|Approved| AD_APROD["6. Apply Prod"]
    end

    subgraph REMOTE_STATE["Azure Remote State (Bootstrap)"]
        ST_BOOT["Storage Account: stazinfra..."]
        CONT_DEV["Container: tfstate-dev (Blob Lease Lock)"]
        CONT_PROD["Container: tfstate-prod (Blob Lease Lock)"]
        ST_BOOT --> CONT_DEV
        ST_BOOT --> CONT_PROD
    end

    subgraph DEV_ENV["Development Environment (rg-azinfra-dev-eastus)"]
        DEV_ASP["App Service Plan (B1 Linux)"] --> DEV_APP["Web App: app-azinfra-dev..."]
        DEV_APP -.->|System-Assigned MSI| DEV_KV["Key Vault: kv-azinfra-dev..."]
        DEV_APP -.->|Data & Assets| DEV_ST["Storage Account: stazinfradev..."]
    end

    subgraph PROD_ENV["Production Environment (rg-azinfra-prod-eastus)"]
        PROD_ASP["App Service Plan (S1 Linux / Auto-scale)"] --> PROD_APP["Web App: app-azinfra-prod..."]
        PROD_APP -.->|System-Assigned MSI| PROD_KV["Key Vault: kv-azinfra-prod..."]
        PROD_APP -.->|Geo-Redundant Blobs| PROD_ST["Storage Account (GRS)"]
    end

    AD_PDEV -.->|State Read/Lock| CONT_DEV
    AD_ADEV ==>|Provisions| DEV_ENV
    AD_PPROD -.->|State Read/Lock| CONT_PROD
    AD_APROD ==>|Provisions| PROD_ENV
```

---

## 2. Component Design & Responsibility

| Component | Technology | Responsibility | Sizing / Tier |
|---|---|---|---|
| **Remote State Backend** | Azure Blob Storage | Shared state storage, blob lease concurrency locking, state versioning | Standard LRS, TLS 1.2, Blob Versioning |
| **Identity & Access** | Azure Active Directory & RBAC | System-assigned managed identities, least-privilege role assignment | Built-in roles (`Key Vault Secrets User`, `Contributor`) |
| **Secret Management** | Azure Key Vault | Hardware-backed cryptographic store for database strings & API keys | Standard Tier, RBAC authorization, Soft-Delete |
| **Compute / Web Layer** | Azure Linux App Service | Hosts containerized or Node.js microservices with HTTPS enforcement | Dev: B1 (Basic) / Prod: S1 (Standard Auto-scale) |
| **Object Storage** | Azure Storage Account | Application asset uploads, diagnostics, and container storage | Dev: Standard LRS / Prod: Standard GRS |
| **Orchestration Pipeline** | Azure DevOps YAML | Multi-stage pipeline enforcing format, validation, planning, approval & apply | Hosted Ubuntu runners, Service Connections |

---

## 3. Secret Retrieval Sequence (Managed Identity)

```mermaid
sequenceDiagram
    autonumber
    actor Developer as DevOps Engineer
    participant Pipeline as Azure DevOps Pipeline
    participant Terraform as Terraform CLI
    participant AzureARM as Azure Resource Manager
    participant AppService as Azure Linux Web App
    participant KeyVault as Azure Key Vault

    Developer->>Pipeline: Git Push / PR to main
    Pipeline->>Terraform: terraform init & plan (Remote State)
    Pipeline->>Developer: Publish Plan Artifact for Review
    Developer->>Pipeline: Approve Production Deployment Gate
    Pipeline->>Terraform: terraform apply (prod.tfplan)
    Terraform->>AzureARM: Provision Web App with SystemAssigned Identity
    AzureARM-->>Terraform: Return Web App Principal ID
    Terraform->>AzureARM: Create Role Assignment (Key Vault Secrets User -> Principal ID)
    Terraform->>AzureARM: Configure App Setting: @Microsoft.KeyVault(SecretUri=...)
    AzureARM-->>AppService: Deploy Settings & Start Worker
    AppService->>KeyVault: Authenticate via Azure AD Managed Identity Token
    KeyVault-->>AppService: Inject Secret Directly into Process Memory
    Note over AppService,KeyVault: Zero Plaintext Secrets in Code, Disk, or CI/CD Logs
```

---

## 4. Modular Decomposition

```
modules/
├── resource-group/     # Encapsulates Azure Resource Group lifecycle and unified tagging
├── storage-account/    # Configures HTTPS-only, TLS 1.2, versioned blob containers
├── key-vault/          # Manages Key Vault, soft-delete, RBAC authorizations and secrets
└── app-service/        # Manages Linux App Service Plan, Web App, HTTPS enforcement, and System-Assigned MSI
```

Each module contains:
- `main.tf`: Declarative resource declarations.
- `variables.tf`: Explicit input validation and parameterization.
- `outputs.tf`: Reusable references for module consumers.
