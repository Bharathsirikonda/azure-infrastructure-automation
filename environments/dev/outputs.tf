output "resource_group_name" {
  description = "The name of the provisioned Dev resource group."
  value       = module.resource_group.name
}

output "app_service_name" {
  description = "The name of the provisioned App Service."
  value       = module.app_service.name
}

output "app_service_url" {
  description = "The public URL of the Dev App Service."
  value       = "https://${module.app_service.default_hostname}"
}

output "app_service_managed_identity_principal_id" {
  description = "System-Assigned Managed Identity Principal ID for the App Service."
  value       = module.app_service.principal_id
}

output "key_vault_name" {
  description = "The name of the provisioned Dev Key Vault."
  value       = module.key_vault.name
}

output "key_vault_uri" {
  description = "The URI of the Dev Key Vault."
  value       = module.key_vault.vault_uri
}

output "storage_account_name" {
  description = "The name of the provisioned Dev storage account."
  value       = module.storage_account.name
}
