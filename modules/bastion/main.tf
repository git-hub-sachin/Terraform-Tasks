terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

resource "aws_security_group" "bastion" {
  vpc_id = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "bastion-sg"
  }
}

resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type              = "t3.medium"
  subnet_id                  = var.public_subnet_ids[0]
  key_name                   = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids     = [aws_security_group.bastion.id]
  tags = {
    Name = "bastion-host"
  }
}