##########################
# Main VPC 
##########################
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name

  create_internet_gateway = var.create_internet_gateway
  igw_name                = var.igw_name
}

##########################
# Public subnet 
##########################
module "public_sn" {
  source = "./modules/subnet"
  vpc_id = module.vpc.vpc_id

  sn_name      = var.pub_sn_name
  sn_cidr      = var.pub_sn_cidr
  sn_is_public = var.pub_sn_is_public
  sn_az        = var.pub_sn_az

  rt_name  = var.pub_sn_rt_name
  rt_rules = local.public_sn_rules
}

##########################
# Public subnet 
##########################
module "public_sn_2" {
  source = "./modules/subnet"
  vpc_id = module.vpc.vpc_id

  sn_name      = var.pub_sn_2_name
  sn_cidr      = var.pub_sn_2_cidr
  sn_is_public = var.pub_sn_2_is_public
  sn_az        = var.pub_sn_2_az

  rt_name  = var.pub_sn_2_rt_name
  rt_rules = local.public_sn_2_rules
}

##########################
# Nat gateway 
##########################
module "nat" {
  source    = "./modules/nat"
  nat_sn_id = module.public_sn.sn_id
  nat_name  = var.nat_name
}

##########################
# Private subnet 
##########################
module "private_sn" {
  source = "./modules/subnet"
  vpc_id = module.vpc.vpc_id

  sn_name      = var.pvt_sn_name
  sn_cidr      = var.pvt_sn_cidr
  sn_is_public = var.pvt_sn_is_public
  sn_az        = var.pvt_sn_az

  rt_name  = var.pvt_sn_rt_name
  rt_rules = local.private_sn_rules
}

##########################
# Eks Cluster
##########################
module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name    = "eks-cluster"
  cluster_version = var.eks_custer_version

  cluster_endpoint_public_access = var.eks_cluster_endpoint_public_access

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = [module.private_sn.sn_id]
  control_plane_subnet_ids = [module.private_sn.sn_id, module.public_sn.sn_id, module.public_sn_2.sn_id]

  eks_managed_node_groups = {
    ng1 = {
      min_size       = var.node_group_min_size
      max_size       = var.node_group_max_size
      desired_size   = var.node_group_desired_size
      instance_types = [var.node_group_instance_type]
    }
  }
}

##########################
# Flask ECR
##########################
module "flask_ecr" {
  source   = "./modules/ecr"
  ecr_name = var.flask_ecr_name
}