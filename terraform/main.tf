
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "openai_rg" {
  name     = "openai-rg"
  location = "East US"
}

resource "azurerm_cognitive_account" "openai_account" {
  name                = "openaiaccount${random_id.unique.hex}"
  location            = azurerm_resource_group.openai_rg.location
  resource_group_name = azurerm_resource_group.openai_rg.name
  kind                = "OpenAI"
  sku_name            = "S0"

  network_acls {
    default_action = "Allow"
  }
}

resource "random_id" "unique" {
  byte_length = 4
}

output "openai_endpoint" {
  value = azurerm_cognitive_account.openai_account.endpoint
}

output "openai_key" {
  value = azurerm_cognitive_account.openai_account.primary_access_key
  sensitive = true
}
