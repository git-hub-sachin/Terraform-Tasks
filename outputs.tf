output "vpc_west1_id" {
  description = "VPC ID in us-west-1"
  value       = module.vpc_west1.vpc_id
}

output "vpc_west2_id" {
  description = "VPC ID in us-west-2"
  value       = module.vpc_west2.vpc_id
}

output "eks_west1_endpoint" {
  description = "EKS cluster endpoint in us-west-1"
  value       = module.eks_west1.cluster_endpoint
}

output "eks_west2_endpoint" {
  description = "EKS cluster endpoint in us-west-2"
  value       = module.eks_west2.cluster_endpoint
}

output "bastion_public_ip" {
  description = "Public IP of the bastion host"
  value       = module.bastion.public_ip
}

output "vpc_peering_connection_id" {
  description = "VPC peering connection ID"
  value       = module.vpc_peering.peering_connection_id
}

output "west1_key_file" {
  description = "Path to us-west-1 private key file"
  value       = local_file.west1_private_key.filename
}

output "west2_key_file" {
  description = "Path to us-west-2 private key file"
  value       = local_file.west2_private_key.filename
}