resource "aws_cloudfront_distribution" "distribution" {
  enabled             = var.enable_cloudfront
  comment             = var.comment
  aliases             = split(",", var.aliases)
  default_root_object = var.default_root_object
  price_class         = var.price_class

  origin {
    domain_name = var.origin_domain_name
    origin_id   = var.origin_id
    origin_path = var.origin_path
  }
  
  default_cache_behavior {
    allowed_methods        = split(",", var.allowed_methods)
    cached_mehods          = split(",", var.cached_mehods)
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl
    min_ttl                = var.min_ttl
    path_pattern           = var.path_pattern
    target_origin_id       = var.origin_id
    viewer_protocol_policy = var.viewer_protocol_policy
    
    forwarded_values {
      headers                 = split(",", var.forward_headers)
      query_string            = var.forward_query_string
      query_string_cache_keys = split(",", var.forward_query_string_cache_keys)

      cookies {
        forward = var.cookies_forward
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.default_cert
    acm_certificate_arn            = aws_acm_certificate.cert.arn
    minimum_protocol_version       = var.minimum_protocol_version
    ssl_support_method             = "sni-only"
  }

  restrictions {
    locations        = split(",", var.locations)
    restriction_type = var.locations_restriction_type
  }

  logging_config {
    bucket          = var.logging_bucket
    include_cookies = var.logging_include_cookies
    prefix          = var.logging_prefix
  }

  tags = {
    app   = var.project_name
    owner = var.project_owner
    env   = terraform.workspace
  }
}
