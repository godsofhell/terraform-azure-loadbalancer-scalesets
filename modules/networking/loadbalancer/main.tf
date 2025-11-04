
//for a load balancer you need a public ip address
resource "azurerm_public_ip" "loadip" {
    
  name                = "load-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"

  
}
//to configure Load Balancer
resource "azurerm_lb" "appbalancer" {
  name                = "app-balancer"
  location            = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = "frontend-ip"
    public_ip_address_id = azurerm_public_ip.loadip.id
  }
}
//To configure the Backend Virtual Machines  
resource "azurerm_lb_backend_address_pool" "virtual_machine_pool" {
  loadbalancer_id = azurerm_lb.appbalancer.id
  name            = "VirtualMachinePool"
}

//the backend address pool
resource "azurerm_lb_backend_address_pool_address" "appvmaddress" {
    count = var.number_of_machines
  name                    = "machines${count.index}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.virtual_machine_pool.id
  virtual_network_id      = var.virtual_network_id
  ip_address              = var.network_interface_private_ip_address[count.index]
}
//health probe
resource "azurerm_lb_probe" "probeA" {
  loadbalancer_id = azurerm_lb.appbalancer.id
  name            = "probeA"
  port            = 80
  protocol = "Tcp"
}
//probe rules
resource "azurerm_lb_rule" "RuleA" {
  loadbalancer_id                = azurerm_lb.appbalancer.id
  name                           = "RuleA"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "frontend-ip"
  probe_id = azurerm_lb_probe.probeA.id
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.virtual_machine_pool.id]
}