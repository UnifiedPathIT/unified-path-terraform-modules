# terraform-aws-ec2-web

A single, internet-reachable web server done the right way: its own security
group (HTTP open; SSH off by default), the latest Amazon Linux 2023 AMI selected
automatically, **IMDSv2 enforced**, an **encrypted gp3 root volume**, and a
cloud-init script that installs Nginx and serves a page. Companion to **Cloud 101**
and the early **AWS** series — the "I applied Terraform and got a real, live
thing" moment.

> Free module, MIT-licensed. Part of the public `unified-path-terraform-modules` library.

## Usage (with the vpc module)

```hcl
module "vpc" {
  source              = "github.com/UnifiedPathIT/unified-path-terraform-modules//modules/vpc"
  name                = "upm-web"
  public_subnet_cidrs = ["10.0.0.0/24"]
  private_subnet_cidrs = []
}

module "web" {
  source    = "github.com/UnifiedPathIT/unified-path-terraform-modules//modules/ec2-web"
  name      = "upm-web"
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnet_ids[0]
}

output "url" {
  value = "http://${module.web.public_ip}"
}
```

`terraform apply`, wait a minute for cloud-init, then open the `url` output.

## Note on MiniStack

Unlike the VPC / SG / S3 modules, this one is best run against **real AWS** — it
uses an AMI data-source lookup and a real instance launch, which MiniStack's free
tier doesn't fully emulate. It's Always-Free-tier friendly (t3.micro, 8 GB gp3);
just `terraform destroy` when you're done.

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `name` | string | — (required) | Name prefix. |
| `vpc_id` | string | — (required) | VPC for the security group. |
| `subnet_id` | string | — (required) | Public subnet to launch in. |
| `instance_type` | string | `"t3.micro"` | Instance size. |
| `ami_id` | string | `""` | Pin an AMI; empty = latest AL2023 x86_64. |
| `associate_public_ip` | bool | `true` | Give it a public IP. |
| `http_ingress_cidrs` | list(string) | `["0.0.0.0/0"]` | Who can reach port 80. |
| `ssh_ingress_cidrs` | list(string) | `[]` | Who can reach port 22 (empty = no SSH). |
| `key_name` | string | `""` | EC2 key pair for SSH (optional). |
| `user_data` | string | `""` | Custom cloud-init; empty = install Nginx. |
| `tags` | map(string) | `{}` | Extra tags. |

## Outputs

| Name | Description |
|---|---|
| `instance_id` | EC2 instance ID. |
| `public_ip` | Public IP (or null). |
| `public_dns` | Public DNS name. |
| `security_group_id` | Instance security group ID. |
| `ami_id` | AMI the instance used. |

## Requirements

| Name | Version |
|---|---|
| terraform | >= 1.5.0 |
| aws provider | >= 5.0, < 6.0 |
