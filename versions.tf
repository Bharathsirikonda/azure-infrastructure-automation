terraform {
  required_version = ">= 1.5.0, < 2.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.90.0, < 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
  }

  backend "azurerm" {
    # Values supplied via -backend-config or pipeline
    resource_group_name  = "rg-azinfra-bootstrap-eastus"
    storage_account_name = "stazinfrabootstrapstate"
    container_name       = "tfstate-dev"
    key                  = "terraform.tfstate"
  }
}
