variable "name" {
  type        = string
  description = "The name of the Linux Web App."
}

variable "service_plan_name" {
  type        = string
  description = "The name of the App Service Plan."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "location" {
  type        = string
  description = "The Azure region for the App Service."
}

variable "os_type" {
  type        = string
  description = "The O/S type for the App Services to be hosted in this plan (Linux or Windows)."
  default     = "Linux"
}

variable "sku_name" {
  type        = string
  description = "The SKU for the plan (e.g., B1, P1v2, S1, F1)."
  default     = "B1"
}

variable "app_settings" {
  type        = map(string)
  description = "Map of key-value pairs of App Settings."
  default     = {}
}

variable "python_version" {
  type        = string
  description = "Python runtime version if hosting Python (or leave null if not using Python stack)."
  default     = null
}

variable "node_version" {
  type        = string
  description = "Node runtime version if hosting Node (e.g., 20-lts)."
  default     = "20-lts"
}

variable "health_check_path" {
  type        = string
  description = "The path to be checked for health monitoring."
  default     = "/health"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to App Service and Plan."
  default     = {}
}
