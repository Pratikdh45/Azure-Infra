resource "azurerm_storage_account" "storage" {
  name                     = var.project_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
  name                  = "${var.project_name}-container"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}
