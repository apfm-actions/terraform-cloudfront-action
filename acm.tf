# Remove me after testing
locals {
  alt_names = var.aliases != "" ? split(",", var.aliases) : []
}

resource "aws_acm_certificate" "cert" {
  count                     = var.use_default_cert ? 0 : 1
  domain_name               = var.certificate_domain_name
  validation_method         = "DNS"
  subject_alternative_names = split(",", var.aliases)

  tags = {
    app   = var.project_name
    owner = var.project_owner
    env   = terraform.workspace
    repo  = var.github_repository
  }

  lifecycle {
    create_before_destroy = true
  }
}
