output "vpc_id" {
  value = aws_vpc.this.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "public_subnet_id" {
  value = var.enable_public_subnet ? aws_subnet.public[0].id : null
}

output "route_table_id" {
  value = aws_route_table.private.id
}