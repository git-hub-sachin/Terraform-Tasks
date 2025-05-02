terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "employee-app-tfstate-08642"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
  }
}