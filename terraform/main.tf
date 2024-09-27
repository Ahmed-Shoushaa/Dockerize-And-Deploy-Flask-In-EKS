module "vpc" {
  source = "./modules/vpc"

  vpc_cidr = "10.0.0.0/16"
  vpc_name = "eks-vpc"

  create_internet_gateway = true
  igw_name                = "eks-igw"
}

module "public_sn" {
  source = "./modules/subnet"
  vpc_id = module.vpc.vpc_id

  sn_name      = "eks-public-sn"
  sn_cidr      = "10.0.1.0/24"
  sn_is_public = true
  sn_az = "us-east-1a"

  rt_name      = "eks-pubic-sn-rt"
  rt_rules     = local.public_sn_rules
}

module "nat" {
  source    = "./modules/nat"
  nat_sn_id = module.public_sn.sn_id
  nat_name  = "eks-nat"
}

module "private_sn" {
  source = "./modules/subnet"
  vpc_id = module.vpc.vpc_id

  sn_name = "eks-private-sn"
  sn_cidr = "10.0.2.0/24"
  sn_is_public = false
  sn_az = "us-east-1b"

  rt_name = "eks-private-sn-rt"
  rt_rules = local.private_sn_rules
  depends_on = [  ]
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"

  cluster_name    = "eks-cluster"
  cluster_version = "1.27"

  cluster_endpoint_public_access = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = [module.private_sn.sn_id]
  control_plane_subnet_ids = [module.private_sn.sn_id, module.public_sn.sn_id]

  eks_managed_node_groups = {
    ng1 = {
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      instance_types = ["t3.small"]
    }
  }
}

resource "aws_iam_role" "" {
  name               = ""
  assume_role_policy = file("${path.module}/iam-policy.json")
}