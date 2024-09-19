# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = "eastus"
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = [var.subnet_prefix]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_prefix]
}

# NAT Gateway
resource "azurerm_nat_gateway" "nat_gateway" {
  name                = var.nat_gateway_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_name            = "Standard"
}

# NAT Gateway Association to Subnet
resource "azurerm_subnet_nat_gateway_association" "example" {
  subnet_id      = azurerm_subnet.subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}

# Create the Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = "myacr${random_id.acr_suffix.hex}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true

  tags = {
    environment = "production"
  }
}

# Random suffix to ensure unique ACR name
resource "random_id" "acr_suffix" {
  byte_length = 4
}

# Kubernetes Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name                = "default"
    node_count          = var.default_node_count
    vm_size             = var.node_vm_size
    os_disk_size_gb     = 30
    auto_scaling_enabled = true
    min_count           = var.min_count
    max_count           = var.max_count
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin     = "azure"  # Can also be "kubenet" if required
    load_balancer_sku  = "standard"
    outbound_type      = "loadBalancer"  # Using load balancer for outbound traffic
  }

  tags = {
    environment = "production"
  }
}

# Grant AKS access to ACR
resource "azurerm_role_assignment" "aks_acr" {
  principal_id          = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name  = "AcrPull"
  scope                 = azurerm_container_registry.acr.id
}

