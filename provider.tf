terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.50.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "265a5a8f-b1c3-4233-930e-b078ae240f3b" #Azure Subscription ID
}

provider "azuread" {}