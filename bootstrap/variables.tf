variable "project_name" {
  type        = string
  description = "Base project name used for naming convention."
  default     = "azinfra"
}

variable "environment" {
  type        = string
  description = "Environment identifier (e.g., bootstrap)."
  default     = "bootstrap"
}

variable "location" {
  type        = string
  description = "Azure region where the storage account and resource group will be created."
  default     = "eastus"
}

variable "container_names" {
  type        = list(string)
  description = "List of blob container names for storing environment state files."
  default     = ["tfstate-dev", "tfstate-prod"]
}

variable "tags" {
  type        = map(string)
  description = "Resource tags applied to bootstrap resources."
  default = {
    Project   = "Azure Infrastructure Automation"
    ManagedBy = "Terraform"
    Purpose   = "Terraform Remote State Backend"
    Owner     = "DevOps Team"
  }
}
