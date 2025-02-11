provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  tenant_id       = var.tenant_id
}

resource "random_id" "unique" {
  byte_length = 4
}

resource "azurerm_cognitive_account" "openai_account" {
  name                = "openaiaccount${random_id.unique.hex}"
  location            = azurerm_resource_group.openai_rg.location
  resource_group_name = "openai_rg"
  kind                = "OpenAI"
  sku_name            = "S0" # This is correct for Cognitive Account

  custom_subdomain_name = "openaiaccount${random_id.unique.hex}"

  network_acls {
    default_action = "Allow"
  }
}

resource "azurerm_cognitive_deployment" "gpt4_deployment" {
  name                 = "gpt4-deployment"
  cognitive_account_id = azurerm_cognitive_account.openai_account.id

  model {
    name    = "gpt-4"
    version = "1106-preview"
    format  = "OpenAI"
  }

  sku {
    name     = "Standard" # ✅ Corrected SKU name
    capacity = 10
  }
}

output "openai_endpoint" {
  value = azurerm_cognitive_account.openai_account.endpoint
}

output "openai_key" {
  value     = azurerm_cognitive_account.openai_account.primary_access_key
  sensitive = true
}

output "gpt4_deployment_name" {
  value = azurerm_cognitive_deployment.gpt4_deployment.name
}

output "gpt4_model_version" {
  value = azurerm_cognitive_deployment.gpt4_deployment.model[0].version
}
