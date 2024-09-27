##########################
# Provider
##########################
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {
  default = "us-east-1"
}


##########################
# Main VPC 
##########################
variable "vpc_cidr" {}
variable "vpc_name" {}
variable "create_internet_gateway" {
  type = bool
}
# Internet gateway
variable "igw_name" {}

##########################
# Public subnet 
##########################
variable "pub_sn_name" {}
variable "pub_sn_cidr" {}
variable "pub_sn_is_public" {
  type = bool
}
variable "pub_sn_az" {}
variable "pub_sn_rt_name" {}

##########################
# Nat gateway 
##########################
variable "nat_name" {}

##########################
# Private subnet 
##########################
variable "pvt_sn_name" {}
variable "pvt_sn_cidr" {}
variable "pvt_sn_is_public" {
  type = bool
}
variable "pvt_sn_az" {}
variable "pvt_sn_rt_name" {}

##########################
# Eks Cluster
##########################
variable "eks_cluster_name" {}
variable "eks_custer_version" {}
variable "eks_cluster_endpoint_public_access" {
  type = bool
}
variable "node_group_min_size" {}
variable "node_group_max_size" {}
variable "node_group_desired_size" {}
variable "node_group_instance_type" {}