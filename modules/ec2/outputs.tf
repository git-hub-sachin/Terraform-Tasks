output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "private_instance_id" {
  value = aws_instance.private.id
}

output "private_security_group_id" {
  value = aws_security_group.private.id
}