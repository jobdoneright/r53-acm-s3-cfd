# ACM certificate has to be in us-east-1, but S3 buckets are in us-west-2
provider "aws" {
  region = "us-east-1"
}

# Region-specific provider for S3 buckets
provider "aws" {
  region = "us-west-2"
  alias  = "west"
}
