module "cdn" {
  source = "terraform-aws-modules/cloudfront/aws"

  origin = {
    something = {
      domain_name = "sachin-web-12890.s3-website-us-east-1.amazonaws.com"
      origin_id   = "s3-site"
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "http-only"
        origin_ssl_protocols   = ["TLSv1", "TLSv1.1"]
      }
    }
  }

  default_cache_behavior = {
    target_origin_id           = "s3-site"
    viewer_protocol_policy     = "allow-all"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
  }
  default_root_object = "index.html"
}