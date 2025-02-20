# Health Probes
resource "azurerm_lb_probe" "frontend_probe" {
  name            = "frontend-health-probe"
  loadbalancer_id = azurerm_lb.main.id
  protocol        = "Http"
  port            = 80
  request_path    = "/health"
}

resource "azurerm_lb_probe" "backend_probe" {
  name            = "backend-health-probe"
  loadbalancer_id = azurerm_lb.main.id
  protocol        = "Http"
  port            = 8080
  request_path    = "/api/health"
}
