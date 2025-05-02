output "bastion_public_ip" {
  value       = module.ec2.bastion_public_ip
  description = "Public IP of the bastion host"
}

output "alb_dns_name" {
  value       = "http://${module.alb.alb_dns_name}"
  description = "URL of the ALB DNS name."
  depends_on  = [null_resource.wait_for_alb_app]
}
