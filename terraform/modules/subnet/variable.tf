##########################
# subnet 
##########################
variable "vpc_id" {}
variable "sn_cidr" {}
variable "sn_az" {
  default = null
}
variable "sn_is_public" {
  type = bool
}
variable "sn_name" {}

##########################
# Route Table 
##########################
variable "rt_name" {}
variable "rt_rules" {}