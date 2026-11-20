variable "name" {
  type        = string
  description = "The name of the resource group."
}

variable "location" {
  type        = string
  description = "The Azure region where the resource group will be provisioned."
}

variable "tags" {
  type        = map(string)
  description = "Resource tags."
  default     = {}
}
