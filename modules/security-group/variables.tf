variable "name" {
  description = "Name prefix for the security group."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC the security group belongs to."
  type        = string
}

variable "description" {
  description = "Human-readable description for the security group."
  type        = string
  default     = "Managed by Terraform (Unified Path Media)"
}

variable "ingress_rules" {
  description = <<-EOT
    Inbound rules. Each object:
      description  = short label
      from_port    = start port (e.g. 443)
      to_port      = end port (usually same as from_port)
      protocol     = "tcp" | "udp" | "icmp" | "-1" (all)
      cidr_blocks  = list of source CIDRs (e.g. ["0.0.0.0/0"])
  EOT
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "enable_default_egress" {
  description = "Add an allow-all outbound rule (the usual default). Set false to manage egress yourself."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Extra tags merged onto the security group. The module always adds Project = unified-path-media and ManagedBy = terraform."
  type        = map(string)
  default     = {}
}
