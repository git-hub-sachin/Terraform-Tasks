resource "aws_instance" "nandu-ec2" {
  for_each = var.instances
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  security_groups = var.security_groups
  associate_public_ip_address = var.associate_public_ip_address
  user_data = var.user_data

  tags = {
    Name = "nandu-enterprise-prod-${each.key}"
  }
}

