# -----------------------------------------------------------------------------
# terraform-aws-ec2-web — Unified Path Media
# A single, internet-reachable web server: a security group (HTTP always, SSH
# optional), the latest Amazon Linux 2023 AMI by default, IMDSv2 enforced, an
# encrypted gp3 root volume, and a cloud-init script that serves a page.
# Companion to Cloud 101 / early AWS series.
# -----------------------------------------------------------------------------

locals {
  base_tags = merge(
    {
      Project   = "unified-path-media"
      ManagedBy = "terraform"
    },
    var.tags,
  )

  ami_id = var.ami_id != "" ? var.ami_id : data.aws_ami.al2023[0].id

  default_user_data = <<-EOF
    #!/bin/bash
    dnf -y update
    dnf -y install nginx
    systemctl enable --now nginx
    echo "<h1>Unified Path Media &mdash; it works.</h1>" > /usr/share/nginx/html/index.html
  EOF

  user_data = var.user_data != "" ? var.user_data : local.default_user_data
}

# Latest Amazon Linux 2023 AMI, unless the caller pinned one.
data "aws_ami" "al2023" {
  count = var.ami_id == "" ? 1 : 0

  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# ---- Security group ---------------------------------------------------------
resource "aws_security_group" "this" {
  name        = "${var.name}-sg"
  description = "Web instance security group (Unified Path Media)"
  vpc_id      = var.vpc_id

  tags = merge(local.base_tags, { Name = "${var.name}-sg" })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  for_each = toset(var.http_ingress_cidrs)

  security_group_id = aws_security_group.this.id
  description       = "HTTP"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = each.value

  tags = merge(local.base_tags, { Name = "${var.name}-http" })
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  for_each = toset(var.ssh_ingress_cidrs)

  security_group_id = aws_security_group.this.id
  description       = "SSH"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = each.value

  tags = merge(local.base_tags, { Name = "${var.name}-ssh" })
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.this.id
  description       = "Allow all outbound"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  tags = merge(local.base_tags, { Name = "${var.name}-egress" })
}

# ---- The instance -----------------------------------------------------------
resource "aws_instance" "this" {
  ami                         = local.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.this.id]
  associate_public_ip_address = var.associate_public_ip
  key_name                    = var.key_name != "" ? var.key_name : null
  user_data                   = local.user_data

  # Enforce IMDSv2 (blocks the classic SSRF-to-credentials attack).
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted   = true
    volume_size = 8
    volume_type = "gp3"
  }

  tags = merge(local.base_tags, { Name = var.name })
}
