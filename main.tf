locals {
  use_default_cert = var.domain_names != "" ? false : true
  domain_names = var.domain_names != "" ? split(",", var.domain_names) : []
}

data "aws_s3_bucket" "selected" {
  count = var.origin_is_s3 ? 1 : 0
  bucket = var.origin_domain_name
}

resource "aws_cloudfront_distribution" "distribution" {
  enabled             = var.enable_cloudfront
  comment             = var.comment
  aliases             = local.domain_names
  default_root_object = var.default_root_object
  price_class         = var.price_class

  origin {
    domain_name = var.origin_is_s3 ? data.aws_s3_bucket.selected.0.bucket_regional_domain_name : var.origin_domain_name
    origin_id   = var.origin_id
    origin_path = var.origin_path

    dynamic "custom_origin_config" {
      for_each = var.origin_is_s3 ? [] : ["1"]

      content {
        http_port              = var.origin_http_port
        https_port             = var.origin_https_port
        origin_protocol_policy = var.origin_protocol_policy
        origin_ssl_protocols   = split(",", var.origin_ssl_protocols)
      }
    }

    dynamic "s3_origin_config" {
      for_each = var.origin_is_s3 && var.origin_access_identity != "" ? ["1"] : []

      content {
        origin_access_identity = var.origin_access_identity
      }
    }
  }
  
  default_cache_behavior {
    allowed_methods        = split(",", var.allowed_methods)
    cached_methods         = split(",", var.cached_methods)
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl
    min_ttl                = var.min_ttl
    target_origin_id       = var.origin_id
    viewer_protocol_policy = var.viewer_protocol_policy
    
    forwarded_values {
      headers      = var.forward_headers != "" ? split(",", var.forward_headers) : []
      query_string = var.forward_query_string

      cookies {
        forward = var.forward_cookies
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = local.use_default_cert
    acm_certificate_arn            = local.use_default_cert ? "" : aws_acm_certificate.cert[0].arn
    minimum_protocol_version       = local.use_default_cert ? "TLSv1" : var.minimum_protocol_version
    ssl_support_method             = local.use_default_cert ? "vpi" : "sni-only"
  }

  restrictions {
    geo_restriction {
      locations        = var.restriction_locations != "" ? split(",", var.restriction_locations) : []
      restriction_type = var.locations_restriction_type
    }
  }

  dynamic "logging_config" {
    for_each = var.logging_bucket != "" ? ["1"] : []

    content {
      bucket          = var.logging_bucket
      include_cookies = var.logging_include_cookies
      prefix          = var.logging_prefix
    }
  }

  tags = {
    app   = var.project_name
    owner = var.project_owner
    env   = terraform.workspace
    repo  = var.github_repository
  }
}
