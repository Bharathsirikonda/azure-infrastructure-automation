# Remote state configuration in Azure Blob Storage for Production
# Values can be supplied via CLI:
#   terraform init -backend-config="resource_group_name=rg-azinfra-bootstrap-eastus" \
#                  -backend-config="storage_account_name=<stname>" \
#                  -backend-config="container_name=tfstate-prod" \
#                  -backend-config="key=prod.terraform.tfstate"
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-azinfra-bootstrap-eastus"
    storage_account_name = "stazinfrabootstrapstate"
    container_name       = "tfstate-prod"
    key                  = "prod.terraform.tfstate"
  }
}
