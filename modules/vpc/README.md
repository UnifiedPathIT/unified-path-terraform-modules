# terraform-aws-vpc (starter)

A beginner-friendly but production-shaped AWS VPC: an Internet Gateway, public and
private subnets spread across Availability Zones, route tables wired correctly, and
an **optional** NAT Gateway that is **off by default** so you never get surprised by
its ~$32/mo idle cost.

This is the foundation the other Unified Path Media modules build on. It's the code
companion to the **Cloud Networking** series (Parts 1–2: *VPCs & CIDR blocks*,
*Subnets, route tables & how traffic flows*).

> Free module, MIT-licensed. Part of the public
> [`unified-path-terraform-modules`](https://github.com/UnifiedPathIT/unified-path-terraform-modules)
> library.

## What it creates

- 1 VPC (DNS support + hostnames on)
- 1 Internet Gateway
- N public subnets (auto-assign public IP), round-robin across your AZs
- N private subnets (no public IP)
- A public route table with a `0.0.0.0/0` route to the IGW
- A private route table (default route to the NAT Gateway **only** when enabled)
- Optional: 1 Elastic IP + 1 NAT Gateway (single, cost-aware)

Every resource is tagged `Project = unified-path-media` and `ManagedBy = terraform`,
plus anything you pass in `tags`.

## Usage

```hcl
module "vpc" {
  source = "github.com/UnifiedPathIT/unified-path-terraform-modules//modules/vpc"

  name       = "upm-demo"
  cidr_block = "10.0.0.0/16"
  azs        = ["us-east-1a", "us-east-1b"]

  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]

  enable_nat_gateway = false # flip to true only if private subnets need egress
}
```

See [`examples/vpc-simple`](../../examples/vpc-simple) for a real-AWS run and
[`examples/vpc-ministack`](../../examples/vpc-ministack) for free local testing.

## Test it free, locally (MiniStack)

No AWS account or credentials needed:

```bash
docker run -p 4566:4566 ministackorg/ministack   # start MiniStack
cd examples/vpc-ministack
terraform init && terraform apply
terraform destroy                                 # or just stop the container
```

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `name` | string | — (required) | Name prefix for every resource. |
| `cidr_block` | string | `"10.0.0.0/16"` | IPv4 CIDR for the VPC. |
| `azs` | list(string) | `["us-east-1a","us-east-1b"]` | AZs to spread subnets across. |
| `public_subnet_cidrs` | list(string) | `["10.0.0.0/24","10.0.1.0/24"]` | Public subnet CIDRs (one subnet each). |
| `private_subnet_cidrs` | list(string) | `["10.0.10.0/24","10.0.11.0/24"]` | Private subnet CIDRs (empty = public-only VPC). |
| `enable_nat_gateway` | bool | `false` | Single NAT Gateway for private egress. Costs ~$32/mo when on. |
| `enable_dns_support` | bool | `true` | DNS resolution in the VPC. |
| `enable_dns_hostnames` | bool | `true` | DNS hostnames for public-IP instances. |
| `tags` | map(string) | `{}` | Extra tags merged onto every resource. |

## Outputs

| Name | Description |
|---|---|
| `vpc_id` | ID of the VPC. |
| `vpc_cidr_block` | The VPC's CIDR block. |
| `internet_gateway_id` | ID of the Internet Gateway. |
| `public_subnet_ids` | List of public subnet IDs. |
| `private_subnet_ids` | List of private subnet IDs. |
| `public_route_table_id` | ID of the public route table. |
| `private_route_table_id` | ID of the private route table. |
| `nat_gateway_id` | NAT Gateway ID, or `null` when disabled. |

## Cost & cleanup

- With `enable_nat_gateway = false` (default), everything here is **free** — VPCs,
  subnets, IGWs, and route tables have no hourly charge.
- A NAT Gateway is the one line item that costs money (~$32/mo + data). Only enable
  it when you truly need private-subnet egress, and `terraform destroy` when done.

## Requirements

| Name | Version |
|---|---|
| terraform | >= 1.5.0 |
| aws provider | >= 5.0, < 6.0 |

## Publishing to the Terraform Registry (later)

The public Registry requires **one module per repo**, named `terraform-aws-vpc`, with
semver release tags. When this module is ready to publish, it splits out of this
library into its own `terraform-aws-vpc` repo — see `docs/registry-publishing.md` at
the repo root.
