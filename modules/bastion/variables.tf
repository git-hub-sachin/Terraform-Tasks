variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the bastion host"
  type        = string
}

variable "eks_cidr_west1" {
  description = "CIDR block of the us-west-1 EKS VPC"
  type        = string
}

variable "eks_cidr_west2" {
  description = "CIDR block of the us-west-2 EKS VPC"
  type        = string
}

variable "region" {
  description = "AWS region for the bastion host"
  type        = string
  default     = "us-west-1"
}