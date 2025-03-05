# Key Pair for us-west-1
resource "aws_key_pair" "west1_key" {
  provider   = aws.west1
  key_name   = "eks-key-${var.aws_region_west1}"
  public_key = tls_private_key.west1.public_key_openssh
}

resource "tls_private_key" "west1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "west1_private_key" {
  content  = tls_private_key.west1.private_key_pem
  filename = "${path.module}/eks-key-${var.aws_region_west1}.pem"
  file_permission = "0400"
}

# Key Pair for us-west-2
resource "aws_key_pair" "west2_key" {
  provider   = aws.west2
  key_name   = "eks-key-${var.aws_region_west2}"
  public_key = tls_private_key.west2.public_key_openssh
}

resource "tls_private_key" "west2" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "west2_private_key" {
  content  = tls_private_key.west2.private_key_pem
  filename = "${path.module}/eks-key-${var.aws_region_west2}.pem"
  file_permission = "0400"
}

# VPC in us-west-1
module "vpc_west1" {
  source     = "./modules/vpc"
  providers  = { aws = aws.west1 }
  vpc_cidr   = var.vpc_cidr_west1
  region     = var.aws_region_west1
}

# VPC in us-west-2
module "vpc_west2" {
  source     = "./modules/vpc"
  providers  = { aws = aws.west2 }
  vpc_cidr   = var.vpc_cidr_west2
  region     = var.aws_region_west2
}

# VPC Peering
module "vpc_peering" {
  source          = "./modules/vpc-peering"
  vpc_west1_id    = module.vpc_west1.vpc_id
  vpc_west2_id    = module.vpc_west2.vpc_id
  region_west1    = var.aws_region_west1
  region_west2    = var.aws_region_west2
  vpc_cidr_west1  = var.vpc_cidr_west1
  vpc_cidr_west2  = var.vpc_cidr_west2
  west1_private_rt_id = module.vpc_west1.private_route_table_id
  west1_public_rt_id  = module.vpc_west1.public_route_table_id
  west2_private_rt_id = module.vpc_west2.private_route_table_id
  west2_public_rt_id  = module.vpc_west2.public_route_table_id
  providers = {
    aws.west1 = aws.west1
    aws.west2 = aws.west2
  }
}

# EKS in us-west-1
module "eks_west1" {
  source             = "./modules/eks"
  providers         = { aws = aws.west1 }
  cluster_name      = "west1"
  private_subnet_ids = module.vpc_west1.private_subnet_ids
  vpc_id            = module.vpc_west1.vpc_id
  ssh_key_name      = aws_key_pair.west1_key.key_name
  bastion_cidr      = var.vpc_cidr_west1
}

# EKS in us-west-2
module "eks_west2" {
  source             = "./modules/eks"
  providers         = { aws = aws.west2 }
  cluster_name      = "west2"
  private_subnet_ids = module.vpc_west2.private_subnet_ids
  vpc_id            = module.vpc_west2.vpc_id
  ssh_key_name      = aws_key_pair.west2_key.key_name
  bastion_cidr      = var.vpc_cidr_west1
}

# Bastion in us-west-1
module "bastion" {
  source            = "./modules/bastion"
  providers        = { aws = aws.west1 }
  vpc_id           = module.vpc_west1.vpc_id
  public_subnet_ids = module.vpc_west1.public_subnet_ids
  key_name         = aws_key_pair.west1_key.key_name
  ami_id           = var.bastion_ami_id
  eks_cidr_west1   = var.vpc_cidr_west1
  eks_cidr_west2   = var.vpc_cidr_west2
}