terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region_west1
  alias  = "west1"
}

provider "aws" {
  region = var.aws_region_west2
  alias  = "west2"
}