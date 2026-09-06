# Recording script — terraform-aws-security-group

_Product: Terraform Module Packs · Module: `security-group` · Repo path: `modules/security-group`_
_Series tie-in: Cloud Networking (Part 3: Security Groups vs. NACLs) · Est. runtime: 6–8 min · Lab: MiniStack (free)_

**Find everything for this module:** Drive → 04 Products → Terraform Module Packs → `security-group` (`security-group-index.md` links the code, diagram, and thumbnail).

**Before you hit record**
- MiniStack running: `docker run -p 4566:4566 ministackorg/ministack`
- Terminal open in `examples/security-group-basic`
- Editor showing `modules/security-group/variables.tf` and `main.tf`
- Security-group diagram (Lucid) ready to cut to

## Shot list

| # | Segment | On screen | ~time |
|---|---|---|---|
| 1 | Cold open | Diagram: server with a bouncer at the door | 0:40 |
| 2 | SG vs NACL in one breath | Diagram | 0:50 |
| 3 | The rules input | `variables.tf` | 1:10 |
| 4 | Wire it up | `examples/security-group-basic/main.tf` | 1:10 |
| 5 | plan + apply | terminal | 1:20 |
| 6 | Why separate rule resources | `main.tf` | 1:00 |
| 7 | destroy + outro | terminal | 0:40 |

---

## 1 — Cold open
**[ON SCREEN: diagram — a server with a bouncer at the door]**

A security group is the bouncer standing at the door of your server. It has one job: decide what traffic gets in. Get it too tight and your app won't load; get it too loose and, well, that's how the bad headlines happen. Let's build one that's exactly as open as it needs to be — and no more.

## 2 — Security groups in one breath
**[ON SCREEN: diagram — inbound arrows, some allowed, some blocked]**

Two things worth knowing up front. A security group is **stateful** — if you let a request in, the reply is automatically allowed back out; you don't write a rule for the return trip. And it's **default-deny** on inbound: nothing gets in unless you say so. So building one is really just writing a short guest list of what's allowed.

That's the whole idea. This module turns that guest list into one clean input.

## 3 — The rules input
**[ON SCREEN: `modules/security-group/variables.tf` — the `ingress_rules` block]**

Here's the input that matters: `ingress_rules`. It's a list, and each entry is a plain-English rule — a description, the port range, the protocol, and which source addresses are allowed. Want to allow web traffic? Port 80, TCP, from anywhere. HTTPS? Port 443. That's it.

Outbound defaults to "allow all," which is the normal AWS default, and there's a switch to turn that off if you're locking things down hard.

## 4 — Wire it up
**[ON SCREEN: `examples/security-group-basic/main.tf`]**

We give it the VPC from our first module and a list with two rules — HTTP and HTTPS, open to the world, because this is a public web server. Notice I pass `module.vpc.vpc_id` straight in; the modules are built to snap together like this.

## 5 — plan and apply
**[ON SCREEN: terminal]**
**[RUN: `terraform init && terraform plan`]**

Init, then plan. You'll see the security group itself, plus a separate little resource for each rule. Hold that thought — I'll explain why in a second.

**[RUN: `terraform apply`]**

`yes`, and it's up. Security groups are fully supported on MiniStack, so this is a real end-to-end test on your own machine.

## 6 — Why separate rule resources
**[ON SCREEN: `modules/security-group/main.tf` — the ingress rule resource]**

One design choice worth calling out, because it'll save you pain. Each rule is its own resource instead of being crammed inside the group. The old way meant changing a single rule could force Terraform to tear down and rebuild the whole group — briefly dropping every connection through it. This way, editing one rule touches exactly that one rule. Small thing, big difference at 3 a.m.

## 7 — destroy and outro
**[RUN: `terraform destroy`]**

Tear it down when you're done. Security groups are free, so there's no cost worry here — just good hygiene.

That's your bouncer. Next module puts a real server behind it. Code's linked below, and the newsletter's where the diagrams and the next lessons land.

**[END CARD: repo link + newsletter CTA]**
