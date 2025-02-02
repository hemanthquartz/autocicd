
terraform {
  backend "azurerm" {
    resource_group_name   = "openai-rg"
    storage_account_name  = "tfbackendstatic"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"

    client_id             = var.client_id
    tenant_id             = var.tenant_id
    subscription_id       = var.subscription_id
    use_msi               = false
  }
}
