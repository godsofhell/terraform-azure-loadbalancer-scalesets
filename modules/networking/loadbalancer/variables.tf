variable "location" {
  type        = string
  description = "The name of the Virtual Network."
}
variable "resource_group_name" {
  type        = string
  description = "The name of the Virtual Network."
}
variable "number_of_machines" {
    type = number
    description = "The number of Virtual Machines to create."
}
variable "network_interface_private_ip_address" {
    type = list(string)
    description = "this is the private IP Addresses of the network interface attached"
}
variable "virtual_network_id" {
  type = string
  description = "Virtual network id of the VMs"
}