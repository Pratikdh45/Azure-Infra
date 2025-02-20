# Backend Pools
resource "azurerm_lb_backend_address_pool" "frontend_pool" {
  name            = "frontend-pool"
  loadbalancer_id = azurerm_lb.main.id
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name            = "backend-pool"
  loadbalancer_id = azurerm_lb.main.id
}
