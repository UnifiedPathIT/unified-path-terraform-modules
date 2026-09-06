variable "bucket_name" {
  description = "Globally-unique S3 bucket name. Must be lowercase, 3–63 chars."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name must be 3–63 chars, lowercase letters, numbers, dots or hyphens, and start/end alphanumeric."
  }
}

variable "versioning_enabled" {
  description = "Keep old versions of objects (recommended)."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Allow Terraform to delete a non-empty bucket on destroy. Keep false in anything you care about."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Extra tags merged onto the bucket. The module always adds Project = unified-path-media and ManagedBy = terraform."
  type        = map(string)
  default     = {}
}
