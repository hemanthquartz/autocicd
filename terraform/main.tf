
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  tenant_id       = var.tenant_id
}

resource "azurerm_cognitive_account" "openai_account" {
  name                = "openaiaccount"
  location            = "East US"
  resource_group_name = "openai_rg"
  kind                = "OpenAI"
  sku_name            = "S0"

  custom_subdomain_name = "openai"

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
  value     = azurerm_cognitive_account.openai_account.primary_access_key
  sensitive = true
}
