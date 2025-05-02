provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "employee-app-tfstate-08642"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
  }
}

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

# resource "null_resource" "wait_for_app_ready" {
#   depends_on = [module.ec2.private_instance_ip]

#   provisioner "remote-exec" {
#     connection {
#       type                = "ssh"
#       user                = "ubuntu"
#       private_key         = tls_private_key.app_key.private_key_pem
#       host                = module.ec2.private_instance_ip
#       bastion_host        = module.ec2.bastion_public_ip
#       bastion_user        = "ubuntu"
#       bastion_private_key = tls_private_key.app_key.private_key_pem
#     }

#     inline = [
#       "echo 'Waiting for application to start...'",
#       "until curl -s http://localhost:5000 >/dev/null; do echo 'App not ready...'; sleep 10; done",
#       "echo 'App is up!'"
#     ]
#   }
# }


module "alb" {
  source              = "./modules/alb"
  project_name        = var.project_name
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  private_instance_id = module.ec2.private_instance_id
}

resource "null_resource" "wait_for_alb_app" {
  depends_on = [module.alb.alb_dns_name]

  provisioner "local-exec" {
    command = <<EOT
      echo "Waiting for ALB to respond..."
      until curl -s --fail http://${module.alb.alb_dns_name}/; do echo "Not ready..."; sleep 10; done
      echo "App behind ALB is up!"
    EOT
  }
}
