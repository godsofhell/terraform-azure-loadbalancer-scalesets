

output "lb_backhand_pool_address_id" {
    value = azurerm_lb_backend_address_pool.virtual_machine_pool.id
    description = "Contains the id of the load balancer backhand address pool"
}