variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet (optional)"
  type        = string
  default     = null
}

variable "region" {
  description = "AWS region for the VPC"
  type        = string
}

variable "enable_public_subnet" {
  description = "Enable public subnet (default: false)"
  type        = bool
  default     = false
}