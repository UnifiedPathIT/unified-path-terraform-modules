# terraform-aws-security-group

A small, reusable AWS security group. You hand it a list of inbound rules; it
adds the standard allow-all outbound rule (which you can turn off). Companion to
the **Cloud Networking** series (Part 3: *Security Groups vs. NACLs*).

Uses the current `aws_vpc_security_group_ingress_rule` / `_egress_rule` resources
(one rule per source CIDR) rather than deprecated inline blocks, so editing a rule
never forces the whole group to be recreated.

> Free module, MIT-licensed. Part of the public `unified-path-terraform-modules` library.

## Usage

```hcl
module "web_sg" {
  source = "github.com/UnifiedPathIT/unified-path-terraform-modules//modules/security-group"

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
```

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `name` | string | — (required) | Name prefix for the group. |
| `vpc_id` | string | — (required) | VPC the group belongs to. |
| `description` | string | "Managed by Terraform (Unified Path Media)" | Group description. |
| `ingress_rules` | list(object) | `[]` | Inbound rules (see object shape below). |
| `enable_default_egress` | bool | `true` | Add allow-all outbound. |
| `tags` | map(string) | `{}` | Extra tags. |

Each `ingress_rules` entry: `{ description, from_port, to_port, protocol, cidr_blocks }`.
Use `protocol = "-1"` for all protocols (ports are ignored).

## Outputs

| Name | Description |
|---|---|
| `security_group_id` | ID of the security group. |
| `security_group_arn` | ARN of the security group. |
| `security_group_name` | Name of the security group. |

## Requirements

| Name | Version |
|---|---|
| terraform | >= 1.5.0 |
| aws provider | >= 5.0, < 6.0 |
