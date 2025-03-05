variable "aws_region_west1" {
  description = "AWS region for us-west-1"
  type        = string
  default     = "us-west-1"
}

variable "aws_region_west2" {
  description = "AWS region for us-west-2"
  type        = string
  default     = "us-west-2"
}

variable "vpc_cidr_west1" {
  description = "CIDR block for VPC in us-west-1"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_cidr_west2" {
  description = "CIDR block for VPC in us-west-2"
  type        = string
  default     = "10.1.0.0/16"
}

variable "bastion_ami_id" {
  description = "AMI ID for the bastion host in us-west-1"
  type        = string
  default     = "ami-07d2649d67dbe8900"
}