provider "aws" {
  region = var.region_1
  alias  = "region_1"
}

provider "aws" {
  region = var.region_2
  alias  = "region_2"
}

# VPC 1 in Region 1
module "vpc_1" {
  source             = "./modules/vpc"
  vpc_name           = "vpc-1"
  vpc_cidr           = "10.0.0.0/16"
  private_subnet_cidr = "10.0.1.0/24"
  public_subnet_cidr  = "10.0.2.0/24"
  region             = var.region_1
  enable_public_subnet = true
  providers = {
    aws = aws.region_1
  }
}

# VPC 2 in Region 2
module "vpc_2" {
  source             = "./modules/vpc"
  vpc_name           = "vpc-2"
  vpc_cidr           = "10.1.0.0/16"
  private_subnet_cidr = "10.1.1.0/24"
  region             = var.region_2
  providers = {
    aws = aws.region_2
  }
}

# VPC Peering
module "vpc_peering" {
  source                  = "./modules/vpc_peering"
  peering_name            = "vpc-1-to-vpc-2"
  requester_vpc_id        = module.vpc_1.vpc_id
  accepter_vpc_id         = module.vpc_2.vpc_id
  accepter_region         = var.region_2
  requester_route_table_id = module.vpc_1.route_table_id
  accepter_route_table_id  = module.vpc_2.route_table_id
  requester_vpc_cidr      = "10.0.0.0/16"
  accepter_vpc_cidr       = "10.1.0.0/16"
  providers = {
    aws.requester  = aws.region_1
    aws.accepter  = aws.region_2
  }
}

# Bastion Host in VPC-1 (Public)
module "bastion_host" {
  source           = "./modules/ec2"
  instance_name    = "bastion-host"
  vpc_id           = module.vpc_1.vpc_id
  subnet_id        = module.vpc_1.public_subnet_id
  ami_id           = var.ami_id_region_1
  key_name         = var.key_name
  allowed_ssh_cidr = ["0.0.0.0/0"]  # Restrict this in production
  providers = {
    aws = aws.region_1
  }
  depends_on = [ module.vpc_1 ]
}

# Private EC2 in VPC-1
module "private_ec2_vpc1" {
  source           = "./modules/ec2"
  instance_name    = "private-ec2-vpc1"
  vpc_id           = module.vpc_1.vpc_id
  subnet_id        = module.vpc_1.private_subnet_id
  ami_id           = var.ami_id_region_1
  key_name         = var.key_name
  allowed_ssh_cidr = ["10.0.2.0/24"]  # Only allow SSH from bastion subnet
  providers = {
    aws = aws.region_1
  }
}

# Private EC2 in VPC-2
module "private_ec2_vpc2" {
  source           = "./modules/ec2"
  instance_name    = "private-ec2-vpc2"
  vpc_id           = module.vpc_2.vpc_id
  subnet_id        = module.vpc_2.private_subnet_id
  ami_id           = var.ami_id_region_2
  key_name         = var.key_name
  allowed_ssh_cidr = ["10.0.0.0/16"]  # Allow SSH from VPC-1 via peering
  providers = {
    aws = aws.region_2
  }
}