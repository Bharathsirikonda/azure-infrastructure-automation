variable "name" {
  type        = string
  description = "The name of the Key Vault (must be globally unique, 3-24 characters)."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "location" {
  type        = string
  description = "Azure region for the Key Vault."
}

variable "sku_name" {
  type        = string
  description = "The SKU name of the Key Vault (standard or premium)."
  default     = "standard"
}

variable "soft_delete_retention_days" {
  type        = number
  description = "The number of days that items should be retained for once soft-deleted (between 7 and 90)."
  default     = 7
}

variable "purge_protection_enabled" {
  type        = bool
  description = "Is Purge Protection enabled for this Key Vault?"
  default     = false
}

variable "enable_rbac_authorization" {
  type        = bool
  description = "Whether Azure Resource Manager uses RBAC for authorization instead of access policies."
  default     = true
}

variable "secrets" {
  type        = map(string)
  description = "Map of secret names to secret values to initialize inside Key Vault. Keys are secret names, values are secret contents."
  default     = {}
}

variable "reader_principal_ids" {
  type        = list(string)
  description = "List of Azure AD principal IDs (e.g., App Service Managed Identity) granted Key Vault Secrets User role."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to Key Vault."
  default     = {}
}
