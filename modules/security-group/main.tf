# -----------------------------------------------------------------------------
# terraform-aws-security-group — Unified Path Media
# A small, reusable security group. You pass a list of ingress rules; egress
# defaults to allow-all (the normal AWS default) and can be turned off.
# Uses separate aws_vpc_security_group_*_rule resources (the current
# recommended pattern) rather than inline blocks, so rules can change without
# recreating the group.
# -----------------------------------------------------------------------------

locals {
  base_tags = merge(
    {
      Project   = "unified-path-media"
      ManagedBy = "terraform"
    },
    var.tags,
  )

  # AWS models one rule per source CIDR, so flatten (rule x cidr_blocks) into a
  # single keyed map. Stable keys mean adding/removing a CIDR touches only that
  # one rule.
  ingress = merge([
    for idx, r in var.ingress_rules : {
      for cidr in r.cidr_blocks :
      "${r.protocol}-${r.from_port}-${r.to_port}-${idx}-${cidr}" => {
        description = r.description
        from_port   = r.from_port
        to_port     = r.to_port
        protocol    = r.protocol
        cidr        = cidr
      }
    }
  ]...)
}

resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(local.base_tags, { Name = var.name })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = local.ingress

  security_group_id = aws_security_group.this.id
  description       = each.value.description
  ip_protocol       = each.value.protocol
  from_port         = each.value.protocol == "-1" ? null : each.value.from_port
  to_port           = each.value.protocol == "-1" ? null : each.value.to_port
  cidr_ipv4         = each.value.cidr

  tags = merge(local.base_tags, { Name = "${var.name}-in-${each.key}" })
}

# Allow-all egress (the standard default) unless the caller opts out.
resource "aws_vpc_security_group_egress_rule" "all" {
  count = var.enable_default_egress ? 1 : 0

  security_group_id = aws_security_group.this.id
  description       = "Allow all outbound"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  tags = merge(local.base_tags, { Name = "${var.name}-egress-all" })
}
