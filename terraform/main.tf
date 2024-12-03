
module "vpc" {
  source  = "./modules/vpc"
  cidr_block = "192.168.0.0/24"
}

module "instances" {
  source = "./modules/instances"
  vpc_id = module.vpc.vpc_id
  public_subnet_id  = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id
}
