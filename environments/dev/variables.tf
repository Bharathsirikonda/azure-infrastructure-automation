variable "project_name" {
  type        = string
  description = "Project name identifier."
  default     = "azinfra"
}

variable "environment" {
  type        = string
  description = "Environment name."
  default     = "dev"
}

variable "location" {
  type        = string
  description = "Azure region for all resources."
  default     = "eastus"
}

variable "app_service_sku" {
  type        = string
  description = "App Service Plan pricing tier SKU (e.g. B1 for dev)."
  default     = "B1"
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
  description = "Storage account replication type."
  default     = "LRS"
}

variable "initial_secrets" {
  type        = map(string)
  description = "Initial placeholder secrets loaded into Key Vault."
  default = {
    "DatabaseConnectionString" = "Server=tcp:dev-sql.database.windows.net;Database=devdb;Encrypted=True;"
    "ApiKey"                   = "dev-environment-sample-api-key-placeholder"
  }
}

variable "tags" {
  type        = map(string)
  description = "Resource tags applied to all provisioned resources."
  default = {
    Project     = "Azure Infrastructure Automation"
    Environment = "Development"
    ManagedBy   = "Terraform"
    CostCenter  = "Engineering-Dev"
    Owner       = "DevOps Team"
  }
}
