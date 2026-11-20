variable "project_name" {
  type        = string
  description = "Base project name used in naming convention."
  default     = "azinfra"
}

variable "environment" {
  type        = string
  description = "Deployment environment name (dev, staging, prod)."
  default     = "dev"
}

variable "location" {
  type        = string
  description = "Azure region where resources will be created."
  default     = "eastus"
}

variable "app_service_sku" {
  type        = string
  description = "SKU for App Service Plan (e.g. B1 for dev, S1 for prod)."
  default     = "B1"
}

variable "key_vault_sku" {
  type        = string
  description = "SKU for Key Vault (standard or premium)."
  default     = "standard"
}

variable "storage_account_tier" {
  type        = string
  description = "Storage account tier (Standard or Premium)."
  default     = "Standard"
}

variable "storage_account_replication" {
  type        = string
  description = "Storage account replication (LRS, GRS, ZRS)."
  default     = "LRS"
}

variable "initial_secrets" {
  type        = map(string)
  description = "Initial placeholder secrets loaded into Key Vault."
  default = {
    "DatabaseConnectionString" = "Server=tcp:sql.database.windows.net;Database=appdb;Encrypted=True;"
    "ApiKey"                   = "sample-initial-api-key-placeholder"
  }
}

variable "tags" {
  type        = map(string)
  description = "Default resource tags applied across all resources."
  default = {
    Project    = "Azure Infrastructure Automation"
    ManagedBy  = "Terraform"
    Owner      = "DevOps Team"
    CostCenter = "Cloud Operations"
  }
}
