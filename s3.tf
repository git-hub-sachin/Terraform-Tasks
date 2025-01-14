provider "aws" {
  region = "us-east-1"
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  bucket = "sachin-web-12890"
  acl    = "private"
  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  block_public_acls = false
  ignore_public_acls = false
  block_public_policy = false
  restrict_public_buckets = false
  website = {
    index_document = "index.html"
  }

  versioning = {
    enabled = true
  }
}

resource "aws_s3_object" "object" {
  bucket       = "sachin-web-12890"
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
  acl = "public-read"
  depends_on = [ module.s3_bucket ]

}
