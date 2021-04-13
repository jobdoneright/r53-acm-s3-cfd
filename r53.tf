data "aws_route53_zone" "dns_zone" {
  name = "${var.dns_zone}."
}

# Domain validation record - var.dns_zone
resource "aws_route53_record" "dvr" {

  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.dns_zone.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = "60"
}

# DNS - ${var.site_fqdn}
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.dns_zone.zone_id
  name    = var.site_fqdn
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.site_fqdn.domain_name
    zone_id                = aws_cloudfront_distribution.site_fqdn.hosted_zone_id
    evaluate_target_health = false
  }
}

# DNS - ${var.dns_zone}
resource "aws_route53_record" "apex" {
  zone_id = data.aws_route53_zone.dns_zone.zone_id
  name    = var.dns_zone
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.apex.domain_name
    zone_id                = aws_cloudfront_distribution.apex.hosted_zone_id
    evaluate_target_health = false
  }
}
