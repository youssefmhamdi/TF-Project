terraform {
  required_version = ">=0.12"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "4a1b30a5-064b-45d4-8d24-c8caf7880a95"
  tenant_id       = "8f9ad5da-7ead-4274-9972-19cf55bc5d15"
  client_id       = "9ff94ee6-2dc9-4139-af13-60a871fc1c2e"
  client_secret   = "~.X8Q~oWG59gd-vNxOfbgnLCHJQpr_3yo~Uhebzv"
  features {}
}
