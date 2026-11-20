variable "project_name" {
  type        = string
  description = "Project name identifier."
  default     = "azinfra"
}

variable "environment" {
  type        = string
  description = "Environment name."
  default     = "prod"
}

variable "location" {
  type        = string
  description = "Azure region for all resources."
  default     = "eastus"
}

variable "app_service_sku" {
  type        = string
  description = "App Service Plan pricing tier SKU (e.g., S1 for production auto-scale and custom domains)."
  default     = "S1"
}

variable "key_vault_sku" {
  type        = string
  description = "Key Vault SKU name (standard or premium)."
  default     = "standard"
}

variable "storage_account_tier" {
  type        = string
  description = "Storage account tier."
  default     = "Standard"
}

variable "storage_account_replication" {
  type        = string
  description = "Storage account replication type (e.g., GRS for production resilience)."
  default     = "GRS"
}

variable "initial_secrets" {
  type        = map(string)
  description = "Initial placeholder secrets loaded into Key Vault."
  default = {
    "DatabaseConnectionString" = "Server=tcp:prod-sql.database.windows.net;Database=proddb;Encrypted=True;"
    "ApiKey"                   = "prod-environment-sample-api-key-placeholder"
  }
}

variable "tags" {
  type        = map(string)
  description = "Resource tags applied to all provisioned resources."
  default = {
    Project     = "Azure Infrastructure Automation"
    Environment = "Production"
    ManagedBy   = "Terraform"
    CostCenter  = "Engineering-Prod"
    Owner       = "DevOps Team"
  }
}
