output "cloudfront_status" {
  description = "The current status of the distribution"
  value = aws_cloudfront_distribution.distribution.status
}

output "cloudfront_domain_name" {
  description = "The domain name corresponding to the distribution"
  value = aws_cloudfront_distribution.distribution.domain_name
}

output "bucket_website_endpoint" {
  description = "The domain name corresponding to the distribution"
  value = data.aws_s3_bucket.selected.0.website_endpoint
}

output "bucket_website_websitedomain" {
  description = "The domain name corresponding to the distribution"
  value = data.aws_s3_bucket.selected.0.website_domain
}
