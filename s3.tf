terraform {
  backend "s3" {
    bucket         = "terraform-tfstate-file-practical"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
