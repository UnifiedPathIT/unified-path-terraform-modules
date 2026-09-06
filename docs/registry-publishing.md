# Publishing a module to the public Terraform Registry

Reference: https://developer.hashicorp.com/terraform/registry/modules/publish (verified Sept 2026)

1. **One module per repo.** The registry indexes one module per GitHub repository — this repo is a workspace/library, not a registry listing itself.
2. **Repo naming:** `terraform-<PROVIDER>-<NAME>` (e.g. `terraform-aws-landing-zone`). `<PROVIDER>` is the main provider the module targets; `<NAME>` describes the infrastructure.
3. **Public repo.** Must be public — private repos aren't eligible (this is why the paid module packs live in a separate private repo and are sold directly rather than registry-listed).
4. **Standard module structure** — `main.tf`, `variables.tf`, `outputs.tf` at the repo root, `README.md`, and an `examples/` directory if applicable. The registry parses this structure to generate docs automatically.
5. **Semantic version git tags** — e.g. `v1.0.0`. At least one release tag must exist before the module can be published.
6. **Repo description** populates the module's short description on the registry — write a real one before publishing.

## Workflow

1. Build and iterate on the module here, under `modules/<name>/`, against MiniStack (see `tool-stack-pricing.md` in the Starting Side Hustle project).
2. When it's ready to publish: create a new repo named `terraform-<provider>-<name>`, move the module content to its root, tag `v1.0.0`, and submit it at https://registry.terraform.io/.
3. Link back to it from this repo's README once it's live.
