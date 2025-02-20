output "resource_group_name" {
  description = "The name of the created Azure resource group"
  value       = azurerm_resource_group.main.name
}

output "location" {
  description = "The Azure region where resources are deployed"
  value       = azurerm_resource_group.main.location
}

output "vnet_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = azurerm_subnet.public.id
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = azurerm_subnet.private.id
}

output "load_balancer_ip" {
  description = "The public IP address of the load balancer"
  value       = azurerm_public_ip.lb.ip_address
}

output "mysql_server_name" {
  description = "The name of the deployed MySQL flexible server"
  value       = azurerm_mysql_flexible_server.db.name
}

output "frontend_vm_public_ip" {
  description = "Public IP of the frontend VM (if applicable)"
  value       = azurerm_linux_virtual_machine.frontend.public_ip_address
}

output "backend_vm_private_ip" {
  description = "Private IP of the backend VM"
  value       = azurerm_network_interface.backend.private_ip_address
}

output "acr_login_server" {
  description = "Azure Container Registry Login Server"
  value       = azurerm_container_registry.acr.login_server
}

output "lb_public_ip" {
  value = azurerm_public_ip.lb.ip_address
}
