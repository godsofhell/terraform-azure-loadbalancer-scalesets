variable "resource_group_name" {
    type = string 
    description = "contains the name of resource group "
}
variable "location" {
    type = string 
    description = "contains the location of resource group "
}
variable "vnet_name" {
  type        = string
  description = "The name of the Virtual Network."
}
variable "vnet_address_prefix" {
  type        = string
  description = "The address space that is used by the Virtual Network."
}
variable "vnet_subnet_count"{
    type = number
    description = "The number of subnets to create in the Virtual Network."
}
variable "public_ip_address_count" {
  type        = number
  description = "The number of Public IPs to create."
}
variable "network_interface_count" {
  type        = number
  description = "The number of network interfaces to create."
}
variable "network_security_group_rules" {
  type        = list(object(
    {
      priority = number
      destination_port_range = string
    }
  ))
  description = "This variable defines the network security group rules."
}
variable "vm_count" {
    type = number
    description = "The number of Virtual Machines to create."
}
variable "number_of_machines" {
    type = number
    description = "The number of Virtual Machines to create."
}
/*variable "network_interface_private_ip_address" {
    type = list(string)
    description = "this is the private IP Addresses of the network interface attached"
}
variable "virtual_network_id" {
  type = string
  description = "Virtual network id of the VMs"
}*/