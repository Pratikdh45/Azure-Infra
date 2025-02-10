resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_public_ip" "lb" {
  name                = "${var.project_name}-lb-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "main" {
  name                = "${var.project_name}-lb"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb.id
  }
}

# Backend Pools
resource "azurerm_lb_backend_address_pool" "frontend_pool" {
  name            = "frontend-pool"
  loadbalancer_id = azurerm_lb.main.id
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name            = "backend-pool"
  loadbalancer_id = azurerm_lb.main.id
}

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
}

output "lb_public_ip" {
  value = azurerm_public_ip.lb.ip_address
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.acr_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = true
}