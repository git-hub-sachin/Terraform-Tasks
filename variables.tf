variable "aws_region_west1" {
  description = "AWS region for us-west-1"
  default     = "us-west-1"
  type        = string
}

variable "aws_region_west2" {
  description = "AWS region for us-west-2"
  default     = "us-west-2"
  type        = string
}

variable "vpc_cidr_west1" {
  description = "CIDR block for VPC in us-west-1"
  default     = "10.0.0.0/16"
  type        = string
}

variable "vpc_cidr_west2" {
  description = "CIDR block for VPC in us-west-2"
  default     = "10.1.0.0/16"
  type        = string
}