# Hosted zone in Route53
#resource "aws_route53_zone" "dns_zone" {
#  name = "${var.dns_zone}."
#}

data "aws_route53_zone" "dns_zone" {
  name = "${var.dns_zone}."
}

# Domain validation record - ${var.dns_zone}
resource "aws_route53_record" "dvr1" {
  zone_id = "${data.aws_route53_zone.dns_zone.zone_id}"
  name    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
}

# Domain validation record - ${var.site_fqdn}
resource "aws_route53_record" "dvr2" {
  zone_id = "${data.aws_route53_zone.dns_zone.zone_id}"
  name    = "${aws_acm_certificate.cert.domain_validation_options.1.resource_record_name}"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_acm_certificate.cert.domain_validation_options.1.resource_record_value}"]
}

# DNS - ${var.site_fqdn}
resource "aws_route53_record" "www" {
  zone_id = "${data.aws_route53_zone.dns_zone.zone_id}"
  name    = "${var.site_fqdn}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.site_fqdn.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.site_fqdn.hosted_zone_id}"
    evaluate_target_health = false
  }
}

# DNS - ${var.dns_zone}
resource "aws_route53_record" "apex" {
  zone_id = "${data.aws_route53_zone.dns_zone.zone_id}"
  name    = "${var.dns_zone}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.apex.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.apex.hosted_zone_id}"
    evaluate_target_health = false
  }
}
