output "cloudfront_status" {
  description = "The current status of the distribution"
  value = aws_cloudfront_distribution.distribution.status
}

output "cloudfront_domain_name" {
  description = "The domain name corresponding to the distribution"
  value = aws_cloudfront_distribution.distribution.domain_name
}
