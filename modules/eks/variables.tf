variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "ssh_key_name" {
  description = "SSH key name for worker nodes"
  type        = string
}

variable "bastion_cidr" {
  description = "CIDR block of the bastion host VPC"
  type        = string
}