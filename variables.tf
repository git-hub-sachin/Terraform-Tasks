variable "region_1" {
  description = "AWS region for VPC 1"
  type        = string
  default     = "us-east-1"
}

variable "region_2" {
  description = "AWS region for VPC 2"
  type        = string
  default     = "us-west-2"
}

variable "ami_id_region_1" {
  description = "AMI ID for EC2 in region 1"
  type        = string
  default     = "ami-04b4f1a9cf54c11d0" 
}

variable "ami_id_region_2" {
  description = "AMI ID for EC2 in region 2"
  type        = string
  default     = "ami-00c257e12d6828491"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = "EMA-EKS"
}