terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region_west1
  alias  = "west1"
}

provider "aws" {
  region = var.aws_region_west2
  alias  = "west2"
}

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
}

module "vpc_west1" {
  source    = "./modules/vpc"
  providers = { aws = aws.west1 }
  region    = var.aws_region_west1
  vpc_cidr  = var.vpc_cidr_west1
}

module "vpc_west2" {
  source    = "./modules/vpc"
  providers = { aws = aws.west2 }
  region    = var.aws_region_west2
  vpc_cidr  = var.vpc_cidr_west2
}

module "eks_west1" {
  source             = "./modules/eks"
  providers         = { aws = aws.west1 }
  cluster_name      = "west1"
  private_subnet_ids = module.vpc_west1.private_subnet_ids
  vpc_id            = module.vpc_west1.vpc_id
  ssh_key_name      = aws_key_pair.west1_key.key_name
}

module "eks_west2" {
  source             = "./modules/eks"
  providers         = { aws = aws.west2 }
  cluster_name      = "west2"
  private_subnet_ids = module.vpc_west2.private_subnet_ids
  vpc_id            = module.vpc_west2.vpc_id
  ssh_key_name      = aws_key_pair.west2_key.key_name
}

module "bastion" {
  source            = "./modules/bastion"
  providers        = { aws = aws.west1 }
  vpc_id           = module.vpc_west1.vpc_id
  public_subnet_ids = module.vpc_west1.public_subnet_ids
  key_name         = aws_key_pair.west1_key.key_name
  ami_id           = "ami-07d2649d67dbe8900"
}

resource "aws_vpc_peering_connection" "west1_to_west2" {
  provider    = aws.west1
  vpc_id      = module.vpc_west1.vpc_id
  peer_vpc_id = module.vpc_west2.vpc_id
  peer_region = var.aws_region_west2
  auto_accept = false
}

resource "aws_vpc_peering_connection_accepter" "west2" {
  provider                  = aws.west2
  vpc_peering_connection_id = aws_vpc_peering_connection.west1_to_west2.id
  auto_accept              = true
}