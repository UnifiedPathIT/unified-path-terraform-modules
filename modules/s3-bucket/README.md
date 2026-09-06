# terraform-aws-s3-bucket

A single S3 bucket with the safe defaults every bucket should have, so "your
first real resource" isn't also your first public-data leak:

- **All public access blocked** (the classic S3 footgun)
- **Encryption at rest** (SSE-S3 / AES256, bucket keys on)
- **Versioning on** (recover from overwrites and deletes)
- **ACLs disabled** (`BucketOwnerEnforced` — the modern default)

Companion to **Cloud 101** and **Terraform Part 4** ("your first real resource").

> Free module, MIT-licensed. Part of the public `unified-path-terraform-modules` library.

## Usage

```hcl
module "bucket" {
  source = "github.com/UnifiedPathIT/unified-path-terraform-modules//modules/s3-bucket"

  bucket_name = "upm-demo-unique-name-123"  # must be globally unique
}
```

## Test it free, locally (MiniStack)

S3 is fully supported by MiniStack:

```bash
docker run -p 4566:4566 ministackorg/ministack
cd examples/s3-bucket-basic
terraform init && terraform apply
terraform destroy
```

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `bucket_name` | string | — (required) | Globally-unique bucket name (3–63 chars, lowercase). |
| `versioning_enabled` | bool | `true` | Keep old object versions. |
| `force_destroy` | bool | `false` | Let Terraform delete a non-empty bucket. |
| `tags` | map(string) | `{}` | Extra tags. |

## Outputs

| Name | Description |
|---|---|
| `bucket_id` | Bucket name/ID. |
| `bucket_arn` | Bucket ARN. |
| `bucket_domain_name` | Regional domain name. |

## Requirements

| Name | Version |
|---|---|
| terraform | >= 1.5.0 |
| aws provider | >= 5.0, < 6.0 |
