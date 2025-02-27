# Create Azure AD User
resource "azuread_user" "vm_admin" {
  user_principal_name = "${var.user_principal_name}@Megha3624outlook.onmicrosoft.com"
  display_name        = var.display_name
  mail_nickname       = var.mail_nickname
  password            = var.password
}

# Assign IAM Role to Frontend VM
resource "azurerm_role_assignment" "frontend_vm_role" {
  scope                = azurerm_linux_virtual_machine.frontend.id # Scope it to the frontend VM only
  role_definition_name = "Virtual Machine Contributor"             # Assign necessary role
  principal_id         = azuread_user.vm_admin.object_id
}

# Assign Role to VNet
resource "azurerm_role_assignment" "vnet_role" {
  scope                = azurerm_virtual_network.main.id # Replace with your actual VNet resource
  role_definition_name = "Network Contributor"           # Allows managing network settings
  principal_id         = azuread_user.vm_admin.object_id
}