variable "name" {
  type        = string
  description = "Name of the storage account (must be unique globally, 3-24 lowercase alphanumeric)."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "location" {
  type        = string
  description = "Azure region for the storage account."
}

variable "account_tier" {
  type        = string
  description = "Tier to use for this storage account (Standard or Premium)."
  default     = "Standard"
}

variable "account_replication_type" {
  type        = string
  description = "Replication type (LRS, GRS, RAGRS, ZRS)."
  default     = "LRS"
}

variable "min_tls_version" {
  type        = string
  description = "Minimum supported TLS version."
  default     = "TLS1_2"
}

variable "enable_https_traffic_only" {
  type        = bool
  description = "Boolean flag which forces HTTPS traffic only."
  default     = true
}

variable "containers" {
  type        = list(string)
  description = "List of blob containers to create inside this storage account."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the storage account."
  default     = {}
}
