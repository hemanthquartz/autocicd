
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

variable "subscription_id" {
  description = "The Azure subscription ID"
  type        = string
}

resource "azurerm_resource_group" "openai_rg" {
  name     = "openai-rg"
  location = "East US"
}

resource "azurerm_storage_account" "tf_backend" {
  name                     = "tfbackend${random_id.unique.hex}"
  resource_group_name      = azurerm_resource_group.openai_rg.name
  location                 = azurerm_resource_group.openai_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tf_state" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tf_backend.name
  container_access_type = "private"
}

resource "random_id" "unique" {
  byte_length = 4
}

resource "azurerm_cognitive_account" "openai_account" {
  name                = "openaiaccount${random_id.unique.hex}"
  location            = azurerm_resource_group.openai_rg.location
  resource_group_name = azurerm_resource_group.openai_rg.name
  kind                = "OpenAI"
  sku_name            = "S0"

  custom_subdomain_name = "openaiaccount${random_id.unique.hex}"

  network_acls {
    default_action = "Allow"
  }
}

output "openai_endpoint" {
  value = azurerm_cognitive_account.openai_account.endpoint
}

output "openai_key" {
  value     = azurerm_cognitive_account.openai_account.primary_access_key
  sensitive = true
}
