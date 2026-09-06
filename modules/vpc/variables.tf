variable "name" {
  description = "Name prefix applied to the VPC and every resource it creates (e.g. \"upm-demo\")."
  type        = string
}

variable "cidr_block" {
  description = "The IPv4 CIDR block for the VPC. /16 gives you room to grow; /24 is fine for a small lab."
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.cidr_block, 0))
    error_message = "cidr_block must be a valid IPv4 CIDR, e.g. \"10.0.0.0/16\"."
  }
}

variable "azs" {
  description = "Availability Zones to spread subnets across. Subnets are distributed round-robin over this list."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]

  validation {
    condition     = length(var.azs) > 0
    error_message = "Provide at least one Availability Zone."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (route to the internet via the Internet Gateway). One subnet per entry."
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (no direct inbound from the internet). One subnet per entry. Leave empty for a public-only VPC."
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "enable_nat_gateway" {
  description = "Give private subnets outbound internet access via a single NAT Gateway. OFF by default because a NAT Gateway costs ~$32/mo even when idle. Turn it on only when private resources must reach the internet."
  type        = bool
  default     = false
}

variable "enable_dns_support" {
  description = "Enable DNS resolution in the VPC."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Assign DNS hostnames to instances with public IPs."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Extra tags merged onto every resource. The module always adds Project = unified-path-media and ManagedBy = terraform."
  type        = map(string)
  default     = {}
}
