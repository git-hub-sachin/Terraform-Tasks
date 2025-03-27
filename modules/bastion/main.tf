resource "aws_instance" "bastion" {
  ami           = "ami-07d2649d67dbe8900"
  instance_type = "t3.medium"
  subnet_id     = var.public_subnet_id
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    delete_on_termination = true
  }
  tags = {
    Name = "Project-Bastion-Host"
  }
}

resource "aws_security_group" "bastion_sg" {
  vpc_id = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
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
    Name = "Project-Bastion-sg"
  }
}
