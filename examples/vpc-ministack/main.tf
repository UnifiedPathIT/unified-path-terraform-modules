# Example: the same VPC, but pointed at MiniStack for FREE local testing.
#
# 1. Start MiniStack:   docker run -p 4566:4566 ministackorg/ministack
# 2. terraform init && terraform apply
# 3. terraform destroy  (or just stop the container)
#
# No real AWS account, no credentials, no cost. The "test/test" keys and the
# skip_* flags below tell the AWS provider not to phone home to real AWS.

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
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_use_path_style           = true

  # Point the services this module uses at the local MiniStack endpoint.
  endpoints {
    ec2 = "http://localhost:4566"
    sts = "http://localhost:4566"
    iam = "http://localhost:4566"
  }
}

module "vpc" {
  source = "../../modules/vpc"

  name       = "upm-local"
  cidr_block = "10.0.0.0/16"
  azs        = ["us-east-1a", "us-east-1b"]

  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]

  enable_nat_gateway = false

  tags = {
    Environment = "local"
  }
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
