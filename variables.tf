variable "resource_group_name" {
  description = "The name of the Azure resource group"
  type        = string
  default     = "azure-infra-rg"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "Central US"
}

variable "project_name" {
  description = "Project name prefix for resources"
  type        = string
  default     = "azureinfra"
}

variable "vnet_cidr" {
  description = "CIDR block for the virtual network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "db_admin_username" {
  description = "Database administrator username"
  type        = string
  default     = "azureuser"
}

variable "db_admin_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
  default     = "Azureinfrapassword.45#@"
}

variable "acr_name" {
  description = "Azure Container Registry Name"
  type        = string
  default     = "azureinfraacr"
}

variable "acr_sku" {
  description = "SKU of the Azure Container Registry"
  type        = string
  default     = "Basic"
}

variable "mysql_flexible_server_location" {
  description = "Region for MySQL Flexible Server (must support the service)"
  type        = string
  default     = "East US"
}

