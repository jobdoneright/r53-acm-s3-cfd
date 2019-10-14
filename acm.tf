# SSL certificate covering apex and www domains
resource "aws_acm_certificate" "cert" {
  domain_name       = "${var.dns_zone}"
  validation_method = "DNS"

  subject_alternative_names = ["${var.site_fqdn}"]

  tags {
    Name = "${var.dns_zone}"
  }
}

# wait for domain validation to complete
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.dvr1.fqdn}", "${aws_route53_record.dvr2.fqdn}"]
}
