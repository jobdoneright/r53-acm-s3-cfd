# domain, which we'll host on (via apex trickery)
variable "dns_zone" {}
# alternative name, this will redirect to ${var.dns_zone}
variable "site_fqdn" {}
