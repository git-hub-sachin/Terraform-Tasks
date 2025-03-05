variable "vpc_west1_id" {
  description = "VPC ID in us-west-1"
  type        = string
}

variable "vpc_west2_id" {
  description = "VPC ID in us-west-2"
  type        = string
}

variable "region_west1" {
  description = "AWS region for us-west-1"
  type        = string
}

variable "region_west2" {
  description = "AWS region for us-west-2"
  type        = string
}

variable "vpc_cidr_west1" {
  description = "CIDR block for VPC in us-west-1"
  type        = string
}

variable "vpc_cidr_west2" {
  description = "CIDR block for VPC in us-west-2"
  type        = string
}

variable "west1_private_rt_id" {
  description = "Private route table ID in us-west-1"
  type        = string
}

variable "west1_public_rt_id" {
  description = "Public route table ID in us-west-1"
  type        = string
}

variable "west2_private_rt_id" {
  description = "Private route table ID in us-west-2"
  type        = string
}

variable "west2_public_rt_id" {
  description = "Public route table ID in us-west-2"
  type        = string
}