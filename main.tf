module "vpc" {
  source            = "./modules/vpc"
  name              = "nandu-enterprise-vpc"
  cidr              = "10.0.0.0/24"
  azs               = ["us-east-1a", "us-east-1b"]
  public_subnets    = ["10.0.0.0/25"]
  private_subnets   = ["10.0.0.0/25"]
  enable_nat_gateway = true
  single_nat_gateway = true
  tags = {
    name   = "Nandu-Enterprise-VPC"
  }
}

module "public_sg" {
  source    = "./modules/sg"
  vpc_id    = module.vpc.vpc_id
  ingress_rules = {
    name      = "nandu-enterprise-public-sg"
    from_port = [22]
    to_port   = [22, 80]
    protocol  = ["tcp"]
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "private_sg" {
  source    = "./modules/sg"
  vpc_id    = module.vpc.vpc_id
  ingress_rules = {
    name      = "nandu-enterprise-private-sg"
    from_port = [3306]
    to_port   = [3306]
    protocol  = ["tcp"]
    cidr_blocks = ["10.0.0.0/24"]
  }
}

module "public_ec2" {
  source           = "./modules/ec2"
  instances        = { for i in range(1,4) : i => i }
  ami              = "ami-0e2c8caa4b6378d8c"
  instance_type    = "t2.micro"
  subnet_id        = module.vpc.public_subnets[0]
  security_groups  = [module.public_sg.sg_id]
  associate_public_ip_address = true
  user_data        = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install nginx -y
    echo '<h1>Welcome to Nandu Enterprise</h1>' > /var/www/html/index.html
    sudo systemctl start nginx
    sudo systemctl enable nginx
  EOF
}

module "private_ec2" {
  source           = "./modules/ec2"
  instances        = { for i in range(4,7) : i => i }
  ami              = "ami-0e2c8caa4b6378d8c"
  instance_type    = "t2.micro"
  subnet_id        = module.vpc.private_subnets[0]
  security_groups  = [module.private_sg.sg_id]
  associate_public_ip_address = false
  user_data        = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install mysql-server -y
    sudo systemctl start mysql
    sudo systemctl enable mysql
  EOF
}


