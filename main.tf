
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
module "virtualmachines" {
    source = "./modules/Compute/VirtualMachines"
    resource_group_name = var.resource_group_name
    location            = var.location
    vm_count = var.vm_count
    //pass the network interface IDs from network module to VM module
    virtual_network_interface_ids = module.network.virtual_network_interface_ids
    virtual_machine_public_ip_addresses = module.network.public_ip_addresses
    //to ensure that network interfaces are created before VMs
    depends_on = [ module.network ]
}

module "load-balancer" {
    source = "./modules/networking/loadbalancer"
    resource_group_name = var.resource_group_name
    location            = var.location
    number_of_machines = var.number_of_machines
    network_interface_private_ip_address = module.network.network_interface_private_ip_address
    virtual_network_id = module.network.virtual_network_id

}