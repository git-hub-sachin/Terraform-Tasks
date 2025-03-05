output "vpc_west1_id" {
  value = module.vpc_west1.vpc_id
}

output "vpc_west2_id" {
  value = module.vpc_west2.vpc_id
}

output "eks_west1_endpoint" {
  value = module.eks_west1.cluster_endpoint
}

output "eks_west2_endpoint" {
  value = module.eks_west2.cluster_endpoint
}

output "bastion_public_ip" {
  value = module.bastion.public_ip
}

output "vpc_peering_connection_id" {
  value = aws_vpc_peering_connection.west1_to_west2.id
}

output "west1_key_name" {
  value = aws_key_pair.west1_key.key_name
}

output "west1_private_key_file" {
  value = local_file.west1_private_key.filename
  description = "Path to the generated private key file for us-west-1"
}

output "west2_key_name" {
  value = aws_key_pair.west2_key.key_name
}

output "west2_private_key_file" {
  value = local_file.west2_private_key.filename
  description = "Path to the generated private key file for us-west-2"
}