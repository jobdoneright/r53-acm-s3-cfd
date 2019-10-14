# S3 bucket for hosting static website
resource "aws_s3_bucket" "apex" {
  bucket   = "${var.dns_zone}"
  provider = "aws.west"

  website {
    redirect_all_requests_to = "https://${var.site_fqdn}"
  }
}

# S3 bucket for redirecting www to apex domain
resource "aws_s3_bucket" "www_redirect_to_apex" {
  bucket   = "${var.site_fqdn}"
  provider = "aws.west"

  website {
    index_document = "index.html"
  }
}
