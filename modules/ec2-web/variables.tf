variable "name" {
  description = "Name prefix for the instance and its security group."
  type        = string
}

variable "vpc_id" {
  description = "VPC to place the security group in."
  type        = string
}

variable "subnet_id" {
  description = "Public subnet to launch the instance in."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type. t3.micro is the cheap default."
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI to use. Leave empty to auto-select the latest Amazon Linux 2023 x86_64 AMI."
  type        = string
  default     = ""
}

variable "associate_public_ip" {
  description = "Give the instance a public IP so it's reachable from the internet."
  type        = bool
  default     = true
}

variable "http_ingress_cidrs" {
  description = "CIDRs allowed to reach HTTP (port 80)."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ssh_ingress_cidrs" {
  description = "CIDRs allowed to reach SSH (port 22). Empty = no SSH rule (recommended; use SSM instead)."
  type        = list(string)
  default     = []
}

variable "key_name" {
  description = "Optional EC2 key pair name for SSH. Leave empty if you don't need SSH."
  type        = string
  default     = ""
}

variable "user_data" {
  description = "Optional custom cloud-init script. Leave empty to install a simple Nginx page."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Extra tags merged onto every resource. The module always adds Project = unified-path-media and ManagedBy = terraform."
  type        = map(string)
  default     = {}
}
