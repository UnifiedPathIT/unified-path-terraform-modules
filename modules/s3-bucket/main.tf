# -----------------------------------------------------------------------------
# terraform-aws-s3-bucket — Unified Path Media
# A single S3 bucket with the safe defaults every bucket should have:
# encryption on, versioning on, all public access blocked, and bucket-owner
# object ownership (ACLs disabled). Companion to Cloud 101 / Terraform Part 4.
# -----------------------------------------------------------------------------

locals {
  base_tags = merge(
    {
      Project   = "unified-path-media"
      ManagedBy = "terraform"
    },
    var.tags,
  )
}

resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  tags = merge(local.base_tags, { Name = var.bucket_name })
}

# Block ALL public access (the #1 S3 footgun).
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Disable ACLs entirely; the bucket owner owns every object.
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Encrypt objects at rest with SSE (S3-managed keys).
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Keep old versions so an overwrite or delete is recoverable.
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}
