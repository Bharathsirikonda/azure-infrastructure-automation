output "resource_group_name" {
  description = "The name of the provisioned Production resource group."
  value       = module.resource_group.name
}

output "app_service_name" {
  description = "The name of the provisioned Production App Service."
  value       = module.app_service.name
}

output "app_service_url" {
  description = "The public URL of the Production App Service."
  value       = "https://${module.app_service.default_hostname}"
}

output "app_service_managed_identity_principal_id" {
  description = "System-Assigned Managed Identity Principal ID for the Production App Service."
  value       = module.app_service.principal_id
}

output "key_vault_name" {
  description = "The name of the provisioned Production Key Vault."
  value       = module.key_vault.name
}

output "key_vault_uri" {
  description = "The URI of the Production Key Vault."
  value       = module.key_vault.vault_uri
}

output "storage_account_name" {
  description = "The name of the provisioned Production storage account."
  value       = module.storage_account.name
}
