resource "azurerm_mysql_flexible_server" "db" {
  name                = "${var.project_name}-db"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "GP_Standard_D2ds_v4"
  storage {
    size_gb = 20
  }
  administrator_login    = var.username
  administrator_password = var.password
  version                = "8.0.21"
  depends_on             = [azurerm_subnet.private]
  zone                   = "2"
}

resource "azurerm_mysql_flexible_server_firewall_rule" "allow_backend" {
  name                = "allow-backend-access"
  server_name         = azurerm_mysql_flexible_server.db.name
  resource_group_name = var.resource_group_name
  start_ip_address    = "10.0.2.0"
  end_ip_address      = "10.0.2.255"
}
