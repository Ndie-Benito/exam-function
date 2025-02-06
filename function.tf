
# Création du groupe de ressources
resource "azurerm_resource_group" "rg_benito" {
  name     = "rg-function-app"
  location = "East US"
}

# Création du plan de service pour la Function App
resource "azurerm_service_plan" "plan_app_benito" {
  name                     = "function-app-service-plan"
  location                 = azurerm_resource_group.rg_benito.location
  resource_group_name      = azurerm_resource_group.rg_benito.name
  sku_name                 = "S1"
  os_type                  = "Linux"
}

# Création du compte de stockage
resource "azurerm_storage_account" "storage_benito" {
  name                     = "functionappstoragebenito"  # Nom en minuscules
  resource_group_name       = azurerm_resource_group.rg_benito.name
  location                 = azurerm_resource_group.rg_benito.location
  account_tier              = "Standard"
  account_replication_type = "LRS"
}

# Création de la Function App
resource "azurerm_linux_function_app" "app_benito" {
  name                      = "yourfirstnamemcitfunction"
  location                  = azurerm_resource_group.rg_benito.location
  resource_group_name       = azurerm_resource_group.rg_benito.name
  service_plan_id           = azurerm_service_plan.plan_app_benito.id
  storage_account_name      = azurerm_storage_account.storage_benito.name
  storage_account_access_key = azurerm_storage_account.storage_benito.primary_access_key

  site_config {
    # Configuration spécifique à la fonction
  }
}

# Création de la politique WAF
resource "azurerm_web_application_firewall_policy" "waf_benito" {
  name                = "benitomcitfunction"
  resource_group_name = azurerm_resource_group.rg_benito.name
  location            = azurerm_resource_group.rg_benito.location

  # Bloc de règles gérées
  managed_rules {
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"
  }

  # Bloc de règles personnalisées
  custom_rules {
    name     = "allow_all"
    priority = 1
    action   = "Allow"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      operator = "Equals"
      values   = ["/"]  # Condition de correspondance pour la racine
    }
    rule_type = "Match"  # Ajout de l'argument "rule_type"
  }
}
