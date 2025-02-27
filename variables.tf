variable "resource_group_name" {
  description = "The name of the Azure resource group"
  type        = string
  default     = "azure-infra-rg-testing"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "Central US"
}

variable "project_name" {
  description = "Project name prefix for resources"
  type        = string
  default     = "azureinfratesting"
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

variable "username" {
  description = "username"
  type        = string
  default     = "azureuser"
}

variable "password" {
  description = "password"
  type        = string
  sensitive   = true
  default     = "Azureinfrapassword.45#@"
}

variable "acr_name" {
  description = "Azure Container Registry Name"
  type        = string
  default     = "azureinfraacrtesting"
}

variable "acr_sku" {
  description = "SKU of the Azure Container Registry"
  type        = string
  default     = "Basic"
}

variable "mysql_flexible_server_location" {
  description = "Region for MySQL Flexible Server (must support the service)"
  type        = string
  default     = "Central US"
}

variable "user_principal_name" {
  type    = string
  default = "vmadmin"
}

variable "display_name" {
  type    = string
  default = "vmadmin"
}

variable "mail_nickname" {
  type    = string
  default = "vmadmin"
}

variable "cluster_name" {
  description = "k8s cluster name"
  type        = string
  default     = "azure-infra-k8s-testing"
}

variable "k8s_name" {
  description = "k8s name"
  type        = string
  default     = "k8s-testing"
}

variable "replica_count" {
  description = "k8s replica count"
  type        = string
  default     = "3"
}

variable "container_port" {
  description = "container-port"
  type        = string
  default     = "80"
}

variable "target_port" {
  description = "target-port"
  type        = string
  default     = "80"
}

variable "port" {
  description = "port"
  type        = string
  default     = "80"
}

variable "create_role" {
  description = "Flag to control role assignment creation"
  type        = bool
  default     = false # Set to true only if you want Terraform to create the role
}