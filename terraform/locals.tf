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

locals {
  private_sn_rules = {
    internet_access = {
      cidr_block = "0.0.0.0/0"
      gateway_id = module.nat.nat_id
    }
    internal_communication = {
      cidr_block = "10.0.0.0/16"
      gateway_id = "local"
    }
  }
}