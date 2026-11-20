output "resource_group_name" {
  description = "The name of the resource group hosting Terraform state."
  value       = azurerm_resource_group.tfstate.name
}

output "storage_account_name" {
  description = "The globally unique name of the Azure Storage Account hosting remote state."
  value       = azurerm_storage_account.tfstate.name
}

output "container_names" {
  description = "The list of provisioned state containers."
  value       = [for c in azurerm_storage_container.containers : c.name]
}

output "backend_config_dev" {
  description = "Backend configuration snippet for Dev environment."
  value       = <<-EOT
    resource_group_name  = "${azurerm_resource_group.tfstate.name}"
    storage_account_name = "${azurerm_storage_account.tfstate.name}"
    container_name       = "tfstate-dev"
    key                  = "dev.terraform.tfstate"
  EOT
}

output "backend_config_prod" {
  description = "Backend configuration snippet for Prod environment."
  value       = <<-EOT
    resource_group_name  = "${azurerm_resource_group.tfstate.name}"
    storage_account_name = "${azurerm_storage_account.tfstate.name}"
    container_name       = "tfstate-prod"
    key                  = "prod.terraform.tfstate"
  EOT
}
