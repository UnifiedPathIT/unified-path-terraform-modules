# -----------------------------------------------------------------------------
# terraform-aws-vpc (starter) — Unified Path Media
# A beginner-friendly but production-shaped VPC: an Internet Gateway, public and
# private subnets spread across AZs, route tables, and an OPTIONAL NAT Gateway.
# Companion to the Cloud Networking series (Parts 1–2).
# -----------------------------------------------------------------------------

locals {
  # Tags every resource inherits. Project tag makes cleanup/auditing easy.
  base_tags = merge(
    {
      Project   = "unified-path-media"
      ManagedBy = "terraform"
    },
    var.tags,
  )

  # Turn each CIDR list into a keyed map so for_each is stable.
  # element() wraps around var.azs, so subnets round-robin across the AZs.
  public_subnets = {
    for idx, cidr in var.public_subnet_cidrs : tostring(idx) => {
      cidr = cidr
      az   = element(var.azs, idx)
    }
  }

  private_subnets = {
    for idx, cidr in var.private_subnet_cidrs : tostring(idx) => {
      cidr = cidr
      az   = element(var.azs, idx)
    }
  }
}

# ---- The VPC itself ---------------------------------------------------------
resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(local.base_tags, { Name = "${var.name}-vpc" })
}

# ---- Internet Gateway (the VPC's door to the internet) ----------------------
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.base_tags, { Name = "${var.name}-igw" })
}

# ---- Public subnets (auto-assign public IPs, route to the IGW) --------------
resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = merge(local.base_tags, {
    Name = "${var.name}-public-${each.key}"
    Tier = "public"
  })
}

# ---- Private subnets (no public IPs; egress only via NAT, if enabled) --------
resource "aws_subnet" "private" {
  for_each = local.private_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(local.base_tags, {
    Name = "${var.name}-private-${each.key}"
    Tier = "private"
  })
}

# ---- Public routing: one route table, default route to the IGW --------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.base_tags, { Name = "${var.name}-public-rt" })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# ---- Optional NAT Gateway (single, cost-aware) ------------------------------
# Off by default. When on: one Elastic IP + one NAT Gateway in the first public
# subnet, and a default route from the private route table through it.
resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? 1 : 0

  domain = "vpc"

  tags = merge(local.base_tags, { Name = "${var.name}-nat-eip" })
}

resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway ? 1 : 0

  allocation_id = aws_eip.nat[0].id
  subnet_id     = values(aws_subnet.public)[0].id

  tags = merge(local.base_tags, { Name = "${var.name}-nat" })

  depends_on = [aws_internet_gateway.this]
}

# ---- Private routing: one route table; NAT default route only if enabled -----
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.base_tags, { Name = "${var.name}-private-rt" })
}

resource "aws_route" "private_nat" {
  count = var.enable_nat_gateway ? 1 : 0

  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[0].id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}
