provider "aws" {
  alias   = "us-east-1"
  region  = "us-east-1"
  assume_role {
    role_arn = var.aws_assume_role
    external_id = var.aws_external_id
  }
}

resource "aws_acm_certificate" "cert" {
  provider                  = aws.us-east-1
  count                     = local.use_default_cert ? 0 : 1
  domain_name               = local.domain_names[0]
  validation_method         = "DNS"

  subject_alternative_names = slice(local.domain_names,1,length(local.domain_names))

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
