## Modules Overview
**1- VPC Module**

Creates a VPC and attaches an Internet Gateway to it
```hcl
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name

  create_internet_gateway = var.create_internet_gateway
  igw_name                = var.igw_name
}
```
 - create_internet_gateway: takes boolean value to ensure if igw is needed or not

**2. Subnet Module**

Creates a subnet, route table, and associates the route table with the subnet. 

Route table roles are passed using locals.
```hcl
module "subnet" {
  source = "./modules/subnet"
  vpc_id = module.vpc.vpc_id

  sn_name      = var.pub_sn_name
  sn_cidr      = var.pub_sn_cidr
  sn_is_public = var.pub_sn_is_public
  sn_az        = var.pub_sn_az

  rt_name  = var.pub_sn_rt_name
  rt_rules = local.public_sn_rules
}
```
- sn_is_public: takes boolean value to determine if the sn is public or private
- rt_rules: passed as local to provide better traceability
    ```hcl
    locals {
    public_sn_rules = {
        internet_access = {
        cidr_block = "0.0.0.0/0"
        gateway_id = module.vpc.internet_gateway_id[0]
        }
        internal_communication = {
        cidr_block = "10.0.0.0/16"
        gateway_id = "local"
        }
    }
    }
    ```



**3. NAT Module**

Creates an Elastic IP (EIP) and NAT gateway, attaching the NAT to a public subnet. 

Managed separately to avoid dependencies as nat must be attached to public subnet.

```hcl
module "nat" {
  source    = "./modules/nat"
  nat_sn_id = module.public_sn.sn_id
  nat_name  = var.nat_name
}
```

**3. ECR Module**

Creates an ECR Repo. 

```hcl
module "flask_ecr" {
  source   = "./modules/ecr"
  ecr_name = var.flask_ecr_name
}
```