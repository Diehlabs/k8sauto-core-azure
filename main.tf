provider "azurerm" {
  features {}
}

locals {
  tags = {
    region            = "westus"
    environment       = "dev"
    cost_center       = "06660"
    owner             = "t-go"
    product           = "private-aks"
    technical_contact = "def-not-me"
  }
}

resource "azurerm_resource_group" "k8sauto_core" {
  name     = "k8sauto-core"
  location = local.tags.region
  tags     = local.tags
}

resource "azurerm_network_security_group" "k8sauto_core" {
  name                = "k8sauto-core"
  location            = azurerm_resource_group.k8sauto_core.location
  resource_group_name = azurerm_resource_group.k8sauto_core.name
}

resource "azurerm_virtual_network" "aksvnet" {
  name                = "aksnet"
  location            = azurerm_resource_group.k8sauto_core.location
  resource_group_name = azurerm_resource_group.k8sauto_core.name
  address_space       = ["172.16.0.0/23"]
  #dns_servers         = ["10.0.0.4", "10.0.0.5"]

  // ddos_protection_plan {
  //   id     = azurerm_network_ddos_protection_plan.example.id
  //   enable = true
  // }
  tags = local.tags
}

resource "azurerm_subnet" "akscontrolsub" {
  name                 = "akscontrolsub"
  resource_group_name  = azurerm_resource_group.k8sauto_core.name
  virtual_network_name = azurerm_virtual_network.aksvnet.name
  address_prefixes     = ["172.16.0.0/24"]
}

resource "azurerm_subnet" "aksnodesub" {
  name                 = "aksnodesub"
  resource_group_name  = azurerm_resource_group.k8sauto_core.name
  virtual_network_name = azurerm_virtual_network.aksvnet.name
  address_prefixes     = ["172.16.1.0/24"]
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}
