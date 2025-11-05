
//module is used to create a resource group
module "resourcegroup" {
  source              = "./modules/general/resourcegroup"
  resource_group_name = var.resource_group_name
  location            = var.location
}
module "network" {
    source = "./modules/networking/vnet"
    resource_group_name = var.resource_group_name
    location            = var.location
    vnet_name          = var.vnet_name
    vnet_address_prefix = var.vnet_address_prefix
    vnet_subnet_count  = var.vnet_subnet_count
    
    public_ip_address_count = var.public_ip_address_count
    network_interface_count =var.network_interface_count
    network_security_group_rules = var.network_security_group_rules
    //to ensure that resourcegroup is created before vnet
    depends_on = [ module.resourcegroup ]
}
module "scalesets"{
    source = "./modules/Compute/scalesets"
    resource_group_name = var.resource_group_name
    location            = var.location
    subnet_id = module.network.subnet_id
    lb_backhand_pool_address_id = module.loadbalancer.lb_backhand_pool_address_id
}
module "loadbalancer" {
    source = "./modules/networking/loadbalancer"
    resource_group_name = var.resource_group_name
    location            = var.location
    number_of_machines = var.number_of_machines
    network_interface_private_ip_address = module.network.network_interface_private_ip_address
    virtual_network_id = module.network.virtual_network_id

}
