variable "resource_group_name" {
    type = string 
    description = "contains the name of resource group "
}
variable "location" {
    type = string 
    description = "contains the location of resource group "
}
variable "subnet_id" {
    type = list(string)
    description = "Contains te subnet id"
}
variable "lb_backhand_pool_address_id"{
    type = string
    description = " Contains the id of the load balancer backhand pool id"
}