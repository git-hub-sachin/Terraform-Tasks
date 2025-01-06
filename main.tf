provider "aws" {
  region = "us-east-1"
}

# Generate a key pair and download the .pem file
resource "aws_key_pair" "example_key" {
  key_name   = "terra_key"
  public_key = file("~/.ssh/id_ed25519.pub")
}

# Security Group allowing all IPs
resource "aws_security_group" "allow_all" {
  name        = "terra_sg"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance with User Data for NGINX installation
resource "aws_instance" "ubuntu_instance" {
  ami           = "ami-0e2c8caa4b6378d8c"
  instance_type = "t2.micro"

  key_name      = aws_key_pair.example_key.key_name
  security_groups = [aws_security_group.allow_all.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install nginx -y
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF

  tags = {
    Name = "Terraform-Instance"
  }
}

# S3 Bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket = "terraformtaskbucket123"
}

# Upload file to S3 bucket
resource "aws_s3_object" "uploaded_file" {
  bucket = aws_s3_bucket.example_bucket.id
  key    = "uploaded-file.txt"
  source = "/home/giit/Desktop/TerraTest.txt"
  acl    = "private"
}

output "key_pair_file" {
  value = aws_key_pair.example_key.key_name
}

output "instance_public_ip" {
  value = aws_instance.ubuntu_instance.public_ip
}

output "s3_bucket_name" {
  value = aws_s3_bucket.example_bucket.bucket
}
