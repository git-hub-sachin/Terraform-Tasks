output "vpc_1_id" {
  value = module.vpc_1.vpc_id
}

output "vpc_2_id" {
  value = module.vpc_2.vpc_id
}

output "peering_connection_id" {
  value = module.vpc_peering.peering_connection_id
}

output "bastion_public_ip" {
  value = module.bastion_host.public_ip
}

output "private_ec2_vpc1_ip" {
  value = module.private_ec2_vpc1.private_ip
}

output "private_ec2_vpc2_ip" {
  value = module.private_ec2_vpc2.private_ip
}