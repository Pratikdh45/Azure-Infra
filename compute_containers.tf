
data "azurerm_subscription" "current" {}

##### Frontend ######

# Public IP for Frontend VM
resource "azurerm_public_ip" "frontend_ip" {
  name                = "${var.project_name}-frontend-ip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
  sku                 = "Standard" 

  lifecycle {
    ignore_changes = [ sku ]
  }
}

# Frontend NIC with Public IP
resource "azurerm_network_interface" "frontend" {
  name                = "${var.project_name}-frontend-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.private.id
    private_ip_address_allocation = "Static"
    public_ip_address_id          = azurerm_public_ip.frontend_ip.id
    private_ip_address            = "10.0.2.5" 
  }
}

# Frontend VM
resource "azurerm_linux_virtual_machine" "frontend" {
  name                  = "${var.project_name}-frontend-vm"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.frontend.id]
  size                  = "Standard_B1s"

  identity {
    type = "SystemAssigned"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }


  computer_name                   = "frontend"
  admin_username                  = var.db_admin_username
  admin_password                  = var.db_admin_password
  disable_password_authentication = false
}

# Role Assignments
resource "azurerm_role_assignment" "frontend_acr_pull" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_virtual_machine.frontend.identity[0].principal_id
}

resource "azurerm_role_assignment" "frontend_acr_push" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "AcrPush"
  principal_id         = azurerm_linux_virtual_machine.frontend.identity[0].principal_id
}

# Remote Execution with SSH Connection
resource "null_resource" "frontend_provision" {
  depends_on = [
    azurerm_linux_virtual_machine.frontend,
    azurerm_role_assignment.frontend_acr_pull,
    azurerm_role_assignment.frontend_acr_push
  ]
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y docker.io jq",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo usermod -aG docker $USER",
      "curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash",
      "sleep 90",
      "for i in {1..15}; do az login --identity && break || sleep 15; done",
      "az account set --subscription $(az account show --query id -o tsv)",
      "az acr login --name ${azurerm_container_registry.acr.name}",
      "sudo docker pull ${azurerm_container_registry.acr.login_server}/myfrontendimage:latest",
      "sudo docker run -d -p 80:80 ${azurerm_container_registry.acr.login_server}/myfrontendimage:latest"
    ]
  }
  connection {
    type     = "ssh"
    user     = var.db_admin_username
    password = var.db_admin_password
    host     = azurerm_public_ip.frontend_ip.ip_address
  }
} 




##### Backend ######

# Public IP for Backend VM
resource "azurerm_public_ip" "backend_ip" {
  name                = "${var.project_name}-backend-ip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
  sku                 = "Standard" 

  lifecycle {
    ignore_changes = [ sku ]
  }
}

# Backend NIC with Public IP
resource "azurerm_network_interface" "backend" {
  name                = "${var.project_name}-backend-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.private.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.6"
    public_ip_address_id          = azurerm_public_ip.backend_ip.id  
  }
}

# Backend VM
resource "azurerm_linux_virtual_machine" "backend" {
  name                  = "${var.project_name}-backend-vm"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.backend.id]
  size                  = "Standard_B1s"

  identity {
    type = "SystemAssigned"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "backend"
  admin_username                  = var.db_admin_username
  admin_password                  = var.db_admin_password
  disable_password_authentication = false

}
# Role Assignments
resource "azurerm_role_assignment" "backend_acr_pull" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_virtual_machine.backend.identity[0].principal_id
}

resource "azurerm_role_assignment" "backend_acr_push" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "AcrPush"
  principal_id         = azurerm_linux_virtual_machine.backend.identity[0].principal_id
}

# Remote Execution with SSH Connection
resource "null_resource" "backend_provision" {
  depends_on = [
    azurerm_linux_virtual_machine.backend,
    azurerm_role_assignment.backend_acr_pull,
    azurerm_role_assignment.backend_acr_push
  ]

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y docker.io jq",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo usermod -aG docker $USER",
      "curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash",
      "sleep 90",
      "for i in {1..15}; do az login --identity && break || sleep 15; done",
      "az account set --subscription $(az account show --query id -o tsv)",
      "az acr login --name ${azurerm_container_registry.acr.name}",
      "sudo docker pull ${azurerm_container_registry.acr.login_server}/mybackendimage:latest",
      "sudo docker run -d -p 80:5000 ${azurerm_container_registry.acr.login_server}/mybackendimage:latest"
    ]
  }
  connection {
    type     = "ssh"
    user     = var.db_admin_username
    password = var.db_admin_password
    host     = azurerm_public_ip.backend_ip.ip_address
  }
} 
