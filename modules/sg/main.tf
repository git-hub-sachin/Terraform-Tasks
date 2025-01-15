resource "aws_security_group" "nandu-sg" {
  name = var.ingress_rules.name
  vpc_id = var.vpc_id

  dynamic "ingress" {
  for_each = var.ingress_rules.from_port
  content {
    from_port = ingress.value
    to_port = ingress.value
    protocol = var.ingress_rules.protocol[0]
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.ingress_rules.name
  }
}

output "sg_id" {
  value = aws_security_group.nandu-sg.id
}
