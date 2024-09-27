##########################
# VPC 
##########################
variable "vpc_cidr" {}
variable "vpc_name" {}

##########################
# IGW 
##########################
variable "create_internet_gateway" {
  type = bool
}
variable "igw_name" {}