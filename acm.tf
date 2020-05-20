data "aws_route53_zone" "selected" {
  zone_id = var.dns_zone_id_public
}

locals {
  alt_names = var.aliases != "" ? split(",", var.aliases) : []
}

resource "aws_acm_certificate" "cert" {
  count                     = var.default_cert ? 1 : 0
  domain_name               = "${var.name}.${replace(data.aws_route53_zone.selected.name, "/[.]$/", "")}"
  validation_method         = "DNS"
  subject_alternative_names = local.alt_names

  tags = {
    app     = var.name
    project = var.project_name
    owner   = var.project_owner
    email   = var.project_email
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_record" {
  count   = var.default_cert ? length(local.alt_names) + 1 : 0
  zone_id = var.dns_zone_id_public
  name    = aws_acm_certificate.cert.0.domain_validation_options[count.index]["resource_record_name"]
  type    = aws_acm_certificate.cert.0.domain_validation_options[count.index]["resource_record_type"]
  records = [aws_acm_certificate.cert.0.domain_validation_options[count.index]["resource_record_value"]]
  ttl     = 300
}

resource "aws_acm_certificate_validation" "cert_validation" {
  count                   = var.default_cert ? 1 : 0
  certificate_arn         = aws_acm_certificate.cert[0].arn
  validation_record_fqdns = aws_route53_record.cert_record.*.fqdn
}
