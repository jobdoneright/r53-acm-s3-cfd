provider "aws" {
  region = "us-east-1"
}

module "website" {
  source = "../../../"

  # domain, which we'll host on (via apex trickery)
  dns_zone  = "test.jobdoneright.ie"
  # FQDN that will redirect to dns_zone
  site_fqdn = "www.test.jobdoneright.ie"
}
