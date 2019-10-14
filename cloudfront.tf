# CloudFront distribution - apex
resource "aws_cloudfront_distribution" "apex" {
  aliases             = ["${var.dns_zone}"]
  default_root_object = "index.html"
  enabled             = true
  http_version        = "http1.1"
  price_class         = "PriceClass_100"

  origin {
    domain_name = "${aws_s3_bucket.apex.website_endpoint}"
    origin_id   = "S3-${var.dns_zone}"

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "${aws_acm_certificate.cert.arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000

    viewer_protocol_policy = "redirect-to-https"
    target_origin_id       = "S3-${var.dns_zone}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }
}

# CloudFront distribution - ${var.site_fqdn}
# (should redirect to the apex site)
resource "aws_cloudfront_distribution" "site_fqdn" {
  aliases             = ["${var.site_fqdn}"]
  default_root_object = "index.html"
  enabled             = true
  price_class         = "PriceClass_100"

  origin {
    domain_name = "${aws_s3_bucket.www_redirect_to_apex.website_endpoint}"
    origin_id   = "S3-${var.site_fqdn}"

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "${aws_acm_certificate.cert.arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000

    viewer_protocol_policy = "redirect-to-https"
    target_origin_id       = "S3-${var.site_fqdn}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }
}
