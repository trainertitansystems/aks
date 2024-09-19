variable "resource_group_name" {
  description = "The name of the resource group."
  default     = "Titans-rg"
}

variable "location" {
  description = "The Azure region to deploy to."
  default     = "eastus"  # Use a region from India like "centralindia" if needed
}

variable "vnet_name" {
  description = "The name of the Virtual Network."
  default     = "Titans-vnet"
}

variable "subnet_name" {
  description = "The name of the subnet."
  default     = "titans-subnet"
}

variable "subnet_prefix" {
  description = "The address space for the subnet."
  default     = "10.0.0.0/16"
}

variable "nat_gateway_name" {
  description = "The name of the NAT Gateway."
  default     = "titans-nat-gateway"
}

variable "cluster_name" {
  description = "The name of the AKS cluster."
  default     = "Titans-scaledout-cluster"
}

variable "dns_prefix" {
  description = "The DNS prefix for the AKS cluster."
  default     = "titans-aks"
}

variable "default_node_count" {
  description = "The default number of nodes in the node pool."
  default     = 2
}

variable "min_count" {
  description = "Minimum number of nodes for autoscaling."
  default     = 2
}

variable "max_count" {
  description = "Maximum number of nodes for autoscaling."
  default     = 10
}

variable "node_vm_size" {
  description = "The size of the Virtual Machine for the nodes."
  default     = "Standard_DS2_v2"
}

# Authentication
variable "client_id" {
  description = "The Client ID of the Azure AD application."
  default     = "a96326f6-0dc3-4ed2-b9c0-72d72f4863b2"
}

variable "client_secret" {
  description = "The Client Secret of the Azure AD application."
  default     = "zNf8Q~i2YAdgXd2IJ~S2bk_nsVqe2yzyTaClidwQ"
}

variable "tenant_id" {
  description = "The Tenant ID of the Azure subscription."
  default     = "4c8c783d-75d4-4118-8a1e-addec91e4a9a"
}

variable "subscription_id" {
  description = "The Subscription ID of the Azure account."
  default     = "8b107c0d-c1d5-4c8f-a280-8bde452105f1"
}

