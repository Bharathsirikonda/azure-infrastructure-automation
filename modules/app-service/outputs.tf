output "id" {
  description = "The ID of the Linux Web App."
  value       = azurerm_linux_web_app.this.id
}

output "name" {
  description = "The name of the Linux Web App."
  value       = azurerm_linux_web_app.this.name
}

output "default_hostname" {
  description = "The default hostname associated with the App Service (e.g., your-app.azurewebsites.net)."
  value       = azurerm_linux_web_app.this.default_hostname
}

output "principal_id" {
  description = "The Principal ID for the System-Assigned Managed Identity of the Web App."
  value       = azurerm_linux_web_app.this.identity[0].principal_id
}

output "service_plan_id" {
  description = "The ID of the App Service Plan."
  value       = azurerm_service_plan.this.id
}
