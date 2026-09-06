# Recording script — terraform-aws-s3-bucket (secure)

_Product: Terraform Module Packs · Module: `s3-bucket` · Repo path: `modules/s3-bucket`_
_Series tie-in: Cloud 101 / Terraform Part 4 ("your first real resource") · Est. runtime: 6–7 min · Lab: MiniStack (free)_

**Find everything for this module:** Drive → 04 Products → Terraform Module Packs → `s3-bucket` (`s3-bucket-index.md` links the code, diagram, and thumbnail).

**Before you hit record**
- MiniStack running: `docker run -p 4566:4566 ministackorg/ministack`
- Terminal open in `examples/s3-bucket-basic`, with the MiniStack endpoint block uncommented in the provider
- Editor showing `modules/s3-bucket/main.tf`
- A unique bucket name picked

## Shot list

| # | Segment | On screen | ~time |
|---|---|---|---|
| 1 | Cold open | Headline: "S3 bucket leaks…" then our locked bucket | 0:40 |
| 2 | The four safe defaults | `main.tf`, scrolling the resources | 1:30 |
| 3 | Wire it up | `examples/s3-bucket-basic/main.tf` | 0:50 |
| 4 | apply + verify | terminal | 1:10 |
| 5 | Prove it's locked down | terminal / settings | 1:00 |
| 6 | destroy + outro | terminal | 0:40 |

---

## 1 — Cold open
**[ON SCREEN: a blurred "another S3 bucket leak" headline, then cut to our config]**

You've seen the headlines: "company leaks millions of records from an exposed S3 bucket." Almost every one of those is the same mistake — a storage bucket left open to the internet by accident. So the goal today isn't just "make a bucket." It's make a bucket that's locked down correctly by default, so your first real resource isn't also your first incident.

## 2 — The four safe defaults
**[ON SCREEN: `modules/s3-bucket/main.tf`, scrolling]**

This module bakes in the four things every bucket should have, so you can't forget them.

One — **public access blocked**, all four settings on. This is the big one; it's the switch that would've prevented most of those headlines.

Two — **encryption at rest**. Objects are encrypted on disk automatically. Free, no reason not to.

Three — **versioning on**. Overwrite or delete a file by accident and the old version is still there. It's an undo button for your data.

And four — **ACLs disabled**, so ownership is simple and there's no weird legacy permissions to reason about. The modern default.

You get all of that from one input: the bucket name.

## 3 — Wire it up
**[ON SCREEN: `examples/s3-bucket-basic/main.tf`]**

Dead simple — point at the module, give it a name. One catch worth saying out loud: S3 bucket names are **globally unique**, across every AWS customer on earth. So "my-bucket" was taken roughly a decade ago. Add something random. I've uncommented the MiniStack block in the provider here so we can test locally for free.

## 4 — apply and verify
**[ON SCREEN: terminal]**
**[RUN: `terraform init && terraform apply`]**

Init, apply, `yes`. S3 is fully supported on MiniStack, so this behaves just like the real thing. And there's your bucket, with the ARN in the outputs.

## 5 — Prove it's locked down
**[ON SCREEN: highlight the public-access-block + encryption resources in state or console]**

The part people skip: actually confirming it's safe. Public access — blocked. Encryption — on. Versioning — enabled. On real AWS this is exactly what you'd check in the bucket's Permissions tab, and it'd be green across the board. That's the whole point of shipping the defaults in code: you don't have to remember to click these every time.

## 6 — destroy and outro
**[RUN: `terraform destroy`]**

Clean up when you're done. Quick note: destroy will refuse if the bucket has objects in it, unless you set `force_destroy` — that's a guardrail, not a bug.

That's a bucket you can actually trust. Code's linked below; grab the newsletter for the next module and the diagrams.

**[END CARD: repo link + newsletter CTA]**
