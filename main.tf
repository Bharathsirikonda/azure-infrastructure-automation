resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

locals {
  name_prefix = "${var.project_name}-${var.environment}"
  safe_prefix = "${var.project_name}${var.environment}${random_string.suffix.result}"
  merged_tags = merge(var.tags, {
    Environment = var.environment
  })
}

# 1. Resource Group Module
module "resource_group" {
  source   = "./modules/resource-group"
  name     = "rg-${local.name_prefix}-${var.location}"
  location = var.location
  tags     = local.merged_tags
}

# 2. Key Vault Module
module "key_vault" {
  source                     = "./modules/key-vault"
  name                       = "kv-${substr(local.safe_prefix, 0, 20)}"
  resource_group_name        = module.resource_group.name
  location                   = module.resource_group.location
  sku_name                   = var.key_vault_sku
  soft_delete_retention_days = var.environment == "prod" ? 90 : 7
  purge_protection_enabled   = var.environment == "prod" ? true : false
  enable_rbac_authorization  = true
  secrets                    = var.initial_secrets
  reader_principal_ids       = [module.app_service.principal_id]
  tags                       = local.merged_tags
}

# 3. Storage Account Module
module "storage_account" {
  source                   = "./modules/storage-account"
  name                     = "st${substr(local.safe_prefix, 0, 18)}"
  resource_group_name      = module.resource_group.name
  location                 = module.resource_group.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication
  containers               = ["assets", "logs"]
  tags                     = local.merged_tags
}

# 4. App Service Module
module "app_service" {
  source              = "./modules/app-service"
  name                = "app-${local.name_prefix}-${random_string.suffix.result}"
  service_plan_name   = "asp-${local.name_prefix}-${var.location}"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  sku_name            = var.app_service_sku
  node_version        = "20-lts"
  health_check_path   = "/health"

  app_settings = {
    "NODE_ENV"                 = var.environment
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
    "STORAGE_BLOB_ENDPOINT"    = module.storage_account.primary_blob_endpoint
    # Key Vault references resolved securely by App Service Managed Identity
    "DATABASE_URL" = "@Microsoft.KeyVault(VaultName=${module.key_vault.name};SecretName=DatabaseConnectionString)"
    "API_KEY"      = "@Microsoft.KeyVault(VaultName=${module.key_vault.name};SecretName=ApiKey)"
  }

  tags = local.merged_tags
}
