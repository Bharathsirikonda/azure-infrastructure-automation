output "resource_group_name" {
  description = "The name of the provisioned Azure Resource Group."
  value       = module.resource_group.name
}

output "app_service_name" {
  description = "The name of the provisioned Azure Linux App Service."
  value       = module.app_service.name
}

output "app_service_url" {
  description = "The public URL of the deployed App Service."
  value       = "https://${module.app_service.default_hostname}"
}

output "app_service_managed_identity_principal_id" {
  description = "Principal ID of the App Service's System-Assigned Managed Identity."
  value       = module.app_service.principal_id
}

output "key_vault_name" {
  description = "The name of the provisioned Azure Key Vault."
  value       = module.key_vault.name
}

output "key_vault_uri" {
  description = "The URI of the provisioned Azure Key Vault."
  value       = module.key_vault.vault_uri
}

output "storage_account_name" {
  description = "The name of the provisioned Azure Storage Account."
  value       = module.storage_account.name
}
