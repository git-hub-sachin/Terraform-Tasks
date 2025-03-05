terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

resource "aws_security_group" "bastion" {
  vpc_id      = var.vpc_id
  description = "Security group for bastion host"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.eks_cidr_west1, var.eks_cidr_west2]
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
  # iam_instance_profile       = aws_iam_instance_profile.bastion_profile.name

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y

              # Install required dependencies
              sudo apt install -y unzip

              # Install AWS CLI v2
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              sudo ./aws/install
              rm -rf awscliv2.zip aws/

              # Install kubectl
              curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.31.3/2024-12-12/bin/linux/amd64/kubectl
              chmod +x ./kubectl
              mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl
              export PATH=$HOME/bin:$PATH
              echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc

              # Reload .bashrc to apply changes
              source ~/.bashrc
              EOF

  tags = {
    Name = "bastion-host"
  }
  # depends_on = [aws_iam_instance_profile.bastion_profile]
}

# resource "aws_iam_instance_profile" "bastion_profile" {
#   name = "bastion-profile"
#   role = aws_iam_role.bastion_role.name
# }

# resource "aws_iam_role" "bastion_role" {
#   name = "bastion-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action    = "sts:AssumeRole"
#       Effect    = "Allow"
#       Principal = { Service = "ec2.amazonaws.com" }
#     }]
#   })
# }

# resource "aws_iam_role_policy" "bastion_policy" {
#   name = "bastion-policy"
#   role = aws_iam_role.bastion_role.id
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect   = "Allow"
#         Action   = ["eks:DescribeCluster", "eks:ListClusters"]
#         Resource = "*"
#       }
#     ]
#   })
# }