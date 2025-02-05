

# Création du groupe de ressources
resource "azurerm_resource_group" "rg_benito" {
  name     = "rg-function-app"
  location = "East US"
}

# Création du plan de service pour la Function App
resource "azurerm_app_service_plan" "plan_app_benito" {
  name                     = "function-app-service-plan"
  location                 = azurerm_resource_group.rg_benito.location
  resource_group_name      = azurerm_resource_group.rg_benito.name
  kind                     = "Linux"
  reserved                 = true
  sku {
    tier = "Standard"
    size = "S1"
  }
}

# Création de la Function App
resource "azurerm_function_app" "app_benito" {
  name                      = "yourfirstnamemcitfunction"
  location                  = azurerm_resource_group.rg_benito.location
  resource_group_name       = azurerm_resource_group.rg_benito.name
  app_service_plan_id       = azurerm_app_service_plan.plan_app_benito.id  # Correction ici
  os_type                   = "Linux"
}

# Création de la politique WAF
resource "azurerm_web_application_firewall_policy" "example" {
  name                = "benitomcitfunction"
  resource_group_name = azurerm_resource_group.rg_benito.name
  location            = azurerm_resource_group.rg_benito.location
  custom_rules {
    name     = "allow_all"
    priority = 1
    action   = "Allow"
    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      operator = "Equals"
      values   = ["/"]
    }
  }
}
