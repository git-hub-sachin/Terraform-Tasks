provider "aws" {
  region = var.region
}

# resource "aws_s3_bucket" "tfstate" {
#   bucket = var.tfstate_bucket_name
#   tags = {
#     Name = "${var.project_name}-tfstate"
#   }
# }

# resource "aws_s3_bucket_versioning" "tfstate_versioning" {
#   bucket = aws_s3_bucket.tfstate.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }


resource "tls_private_key" "app_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.app_key.private_key_pem
  filename        = "${var.project_name}-key.pem"
  file_permission = "0400"
}

resource "aws_key_pair" "app_key_pair" {
  key_name   = "${var.project_name}-key"
  public_key = tls_private_key.app_key.public_key_openssh
}

module "vpc" {
  source              = "./modules/vpc"
  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidr = var.private_subnet_cidr
  availability_zones  = var.availability_zones
}

module "ec2" {
  source             = "./modules/ec2"
  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_id  = module.vpc.private_subnet_id
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  key_name           = aws_key_pair.app_key_pair.key_name
}

module "alb" {
  source              = "./modules/alb"
  project_name        = var.project_name
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  private_instance_id = module.ec2.private_instance_id
}