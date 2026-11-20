# Remote state configuration in Azure Blob Storage
# Values can be supplied via CLI:
#   terraform init -backend-config="resource_group_name=rg-azinfra-bootstrap-eastus" \
#                  -backend-config="storage_account_name=<stname>" \
#                  -backend-config="container_name=tfstate-dev" \
#                  -backend-config="key=dev.terraform.tfstate"
terraform {
  backend "azurerm" {
    # Partial backend configuration populated dynamically via pipeline or backend-config file
    resource_group_name  = "rg-azinfra-bootstrap-eastus"
    storage_account_name = "stazinfrabootstrapstate"
    container_name       = "tfstate-dev"
    key                  = "dev.terraform.tfstate"
  }
}
