
terraform {
  backend "azurerm" {
    resource_group_name   = "openai-rg"
    storage_account_name  = "tfbackend${random_id.unique.hex}"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}
