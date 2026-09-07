#!/usr/bin/env bash
#
# validate.sh — fmt + validate every module, then plan the VPC example on MiniStack.
#
# Free, local, no cloud calls except MiniStack (localhost:4566). Run from the
# repo root:  ./scripts/validate.sh
#
# Requirements: terraform >= 1.5, docker (for MiniStack). The first run needs
# network so terraform can download the AWS provider.
#
# NOTE: ec2-web is intentionally NOT planned here — it needs live AMI lookups
# and a real instance, so run examples/ec2-web-basic against an AWS sandbox and
# `terraform destroy` right after.

set -euo pipefail

# Resolve repo root from this script's location, so it works from anywhere.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

MODULES=(vpc security-group s3-bucket ec2-web)

echo "==> 0. MiniStack check (localhost:4566)"
if curl -sf http://localhost:4566/_localstack/health >/dev/null 2>&1 \
   || curl -sf http://localhost:4566 >/dev/null 2>&1; then
  echo "    MiniStack is reachable."
else
  echo "    MiniStack not detected. Start it with:"
  echo "      docker run -d -p 4566:4566 ministackorg/ministack"
  echo "    (fmt + validate below still run without it; step 3 plan will fail.)"
fi

echo
echo "==> 1. terraform fmt -recursive"
terraform fmt -recursive

echo
echo "==> 2. validate all modules (HCL + type checks, no cloud calls)"
for m in "${MODULES[@]}"; do
  echo "    -- modules/$m"
  terraform -chdir="modules/$m" init -backend=false -input=false >/dev/null
  terraform -chdir="modules/$m" validate
done

echo
echo "==> 3. plan the VPC example against MiniStack"
terraform -chdir=examples/vpc-ministack init -input=false >/dev/null
terraform -chdir=examples/vpc-ministack plan

echo
echo "==> Done. fmt + validate covered all 4 modules; VPC planned on MiniStack."
echo "    To also plan security-group / s3-bucket on MiniStack, uncomment the"
echo "    MiniStack provider block in their examples/*/main.tf and plan those dirs."
echo "    ec2-web: run examples/ec2-web-basic on a real AWS sandbox, then destroy."
