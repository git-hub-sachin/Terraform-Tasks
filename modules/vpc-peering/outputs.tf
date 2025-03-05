output "peering_connection_id" {
  description = "VPC peering connection ID"
  value       = aws_vpc_peering_connection.west1_to_west2.id
}