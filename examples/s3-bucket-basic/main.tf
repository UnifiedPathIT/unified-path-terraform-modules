# Example: one secure S3 bucket. Fully testable on MiniStack.
#
#   docker run -p 4566:4566 ministackorg/ministack
#   terraform init && terraform apply && terraform destroy
#
# For the MiniStack run, uncomment the local endpoints block in the provider.

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0, < 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  # --- Uncomment for free local testing against MiniStack ---
  # access_key                  = "test"
  # secret_key                  = "test"
  # skip_credentials_validation = true
  # skip_requesting_account_id  = true
  # skip_metadata_api_check     = true
  # s3_use_path_style           = true
  # endpoints { s3 = "http://localhost:4566" }
}

module "bucket" {
  source = "../../modules/s3-bucket"

  # Bucket names are global — change this to something unique before applying.
  bucket_name = "upm-demo-change-me-0001"

  tags = {
    Environment = "demo"
  }
}

output "bucket_arn" {
  value = module.bucket.bucket_arn
}
