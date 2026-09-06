# Example: a live web server in a fresh VPC. Best run against real AWS
# (Always-Free-tier friendly). Open the `url` output after ~1 minute.
#
#   terraform init && terraform apply
#   terraform destroy   # when you're done

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
}

module "vpc" {
  source = "../../modules/vpc"

  name                 = "upm-web"
  public_subnet_cidrs  = ["10.0.0.0/24"]
  private_subnet_cidrs = []
}

module "web" {
  source = "../../modules/ec2-web"

  name      = "upm-web"
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnet_ids[0]

  tags = {
    Environment = "demo"
  }
}

output "url" {
  value = "http://${module.web.public_ip}"
}
