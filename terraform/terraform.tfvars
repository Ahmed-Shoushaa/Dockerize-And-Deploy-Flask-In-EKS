##########################
# Main VPC 
##########################
vpc_cidr                = "10.0.0.0/16"
vpc_name                = "eks-vpc"
# Internet gateway
create_internet_gateway = true
igw_name                = "eks-igw"

##########################
# Public subnet 
##########################
pub_sn_name      = "eks-public-sn"
pub_sn_cidr      = "10.0.1.0/24"
pub_sn_is_public = true
pub_sn_az        = "us-east-1a"
pub_sn_rt_name   = "eks-pubic-sn-rt"

##########################
# Public subnet 2
##########################
pub_sn_2_name      = "eks-public-sn-2"
pub_sn_2_cidr      = "10.0.0.0/24"
pub_sn_2_is_public = true
pub_sn_2_az        = "us-east-1c"
pub_sn_2_rt_name   = "eks-pubic-sn--2rt"

##########################
# Nat gateway 
##########################
nat_name = "eks-nat"

##########################
# Private subnet 
##########################
pvt_sn_name      = "eks-private-sn"
pvt_sn_cidr      = "10.0.2.0/24"
pvt_sn_is_public = false
pvt_sn_az        = "us-east-1b"
pvt_sn_rt_name   = "eks-private-sn-rt"

##########################
# Eks Cluster
##########################
eks_cluster_name                   = "eks-cluster"
eks_custer_version                 = 1.27
eks_cluster_endpoint_public_access = true
# Node Group
node_group_min_size      = 1
node_group_max_size      = 2
node_group_desired_size  = 2
node_group_instance_type = "t3.small"

##########################
# Flask ECR
##########################
flask_ecr_name = "flask"