terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  use_cli         = true
}
# ─── Appel des modules ───────────────────────────
# Resource Group via module
module "rg" {
  source   = "../modules/azure-resource-group"
  name     = "rg-devopsdemo"
  location = var.location
  tags     = { env = "learning", project = "devops-demo" }
}
# ACR via module — utilise les outputs du module rg
module "acr" {
  source              = "../modules/azure-acr"
  name                = "acrdevopsdemo"
  resource_group_name = module.rg.name     # output du module rg
  location            = module.rg.location # output du module rg
  sku                 = "Basic"
}
# Storage Account pour le tfstate (pas de module — ressource unique)
resource "azurerm_storage_account" "tfstate" {
  name                     = "stdevopsdemotfstate"
  resource_group_name      = module.rg.name
  location                 = module.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
resource "azurerm_storage_container" "tfstate" {
  name                 = "tfstate"
  storage_account_name = azurerm_storage_account.tfstate.name
}