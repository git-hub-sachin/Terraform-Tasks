variable "private_subnet_ids" { type = list(string) }

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}
variable "vpc_id" { type = string }
variable "key_name" { type = string }
variable "vpc_cidr" { type = string }