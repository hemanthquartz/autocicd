
terraform {
  backend "azurerm" {
    resource_group_name   = "openai-rg"
    storage_account_name  = "tfbackendstatic"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}
