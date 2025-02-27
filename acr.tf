resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = true
}

# # Grant AKS permission to pull images from ACR
# resource "azurerm_role_assignment" "acr_pull" {
#   count                = var.create_role ? 1 : 0 # Creates the resource only if create_role is true
#   principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity.0.object_id
#   role_definition_name = "AcrPull"
#   scope                = azurerm_container_registry.acr.id

#   lifecycle {
#     ignore_changes = all
#   }
# }