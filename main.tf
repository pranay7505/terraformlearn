# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
   subscription_id = "72c85e04-6d5a-484d-a0ce-325cdfd9fd10"
   client_id = "3e291224-db59-4c21-8b51-0f1468f2510c"
   client_secret = "sm68Q~ywN2XG-~t6tF7fFt3crB2lklIQoOB9DcgV"
   tenant_id = "a1102ec6-f684-4618-84be-d1586d3ecc65"
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "pranay_resorces"
  location = "Central India"
}

