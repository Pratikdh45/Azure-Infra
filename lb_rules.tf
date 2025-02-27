# Listener Rules
resource "azurerm_lb_rule" "frontend_rule" {
  name                           = "frontend-lb-rule"
  loadbalancer_id                = azurerm_lb.main.id
  frontend_ip_configuration_name = "PublicIPAddress"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.frontend_pool.id]
  probe_id                       = azurerm_lb_probe.frontend_probe.id
  enable_tcp_reset               = false

}

resource "azurerm_lb_rule" "backend_rule" {
  name                           = "backend-lb-rule"
  loadbalancer_id                = azurerm_lb.main.id
  frontend_ip_configuration_name = "PublicIPAddress"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                       = azurerm_lb_probe.backend_probe.id
  enable_tcp_reset               = false
}
