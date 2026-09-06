# Unified Path Media — Terraform Modules (Free)

Free, working Terraform modules and code companions to the Unified Path Media blog and YouTube content — built alongside the AWS/Terraform learning-path series (landing zone series, Cloud Architecture, Cloud Networking).

## What lives here

- Companion code for published blog posts and video walkthroughs
- Example/reference configurations that aren't meant to be consumed as a standalone registry module
- Early drafts of modules on their way toward a public Terraform Registry listing

## What does *not* live here

The public Terraform Registry requires **one module per repository**, named `terraform-<PROVIDER>-<NAME>` (e.g. `terraform-aws-vpc`). A module developed here that's ready to publish gets split out into its own dedicated repo under that naming convention — see [`docs/registry-publishing.md`](docs/registry-publishing.md). This repo is the working home and code-companion library, not itself a registry-listed module.

## Structure

```
modules/
  <module-name>/
    main.tf
    variables.tf
    outputs.tf
    README.md
    examples/
```

## License

MIT — see [LICENSE](LICENSE). Free to use, modify, and redistribute.

---
Part of [Unified Path Media](https://unifiedpathit.com) — cloud architecture, Terraform, and AWS content.
