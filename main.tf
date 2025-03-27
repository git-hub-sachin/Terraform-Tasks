module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                = var.azs
}

module "bastion" {
  source          = "./modules/bastion"
  vpc_id          = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_ids[0]
  key_name        = var.key_name
}

module "eks" {
  source             = "./modules/eks"
  private_subnet_ids = module.vpc.private_subnet_ids
  vpc_id             = module.vpc.vpc_id           
  key_name           = var.key_name                
  vpc_cidr           = var.vpc_cidr                
  cluster_name       = var.cluster_name
}