# Example: a web security group (HTTP + HTTPS in) built on top of the vpc module.
# Fully testable on MiniStack (security groups are EC2 API).
#
#   docker run -p 4566:4566 ministackorg/ministack   # for local testing
#   terraform init && terraform apply

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

  name                 = "upm-sg-demo"
  public_subnet_cidrs  = ["10.0.0.0/24"]
  private_subnet_cidrs = []
}

module "web_sg" {
  source = "../../modules/security-group"

  name   = "upm-web"
  vpc_id = module.vpc.vpc_id

  ingress_rules = [
    {
      description = "HTTP from anywhere"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "HTTPS from anywhere"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}

output "security_group_id" {
  value = module.web_sg.security_group_id
}
