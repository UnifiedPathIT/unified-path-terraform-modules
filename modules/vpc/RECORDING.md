# Recording script — terraform-aws-vpc (starter)

_Product: Terraform Module Packs · Module: `vpc` · Repo path: `modules/vpc`_
_Series tie-in: Cloud Networking (Parts 1–2) · Est. runtime: 7–9 min · Lab: MiniStack (free)_

**Find everything for this module:** Drive → 04 Products → Terraform Module Packs → `vpc` (`vpc-index.md` links the code, diagram, and thumbnail).

**Before you hit record**
- MiniStack running: `docker run -p 4566:4566 ministackorg/ministack`
- Repo cloned; terminal open in `examples/vpc-ministack`
- Editor showing `modules/vpc/main.tf` and `variables.tf`
- The VPC diagram (Lucid) ready to cut to; font size bumped in the terminal

## Shot list

| # | Segment | On screen | ~time |
|---|---|---|---|
| 1 | Cold open | Diagram: empty region → VPC appears | 0:40 |
| 2 | What we're building | Diagram with subnets/IGW labeled | 0:50 |
| 3 | Tour the module inputs | `variables.tf` | 1:10 |
| 4 | Wire it up | `examples/vpc-ministack/main.tf` | 1:20 |
| 5 | init + plan | terminal | 1:30 |
| 6 | apply + verify | terminal | 1:20 |
| 7 | Cost + destroy | terminal | 0:50 |
| 8 | Outro / CTA | diagram + repo | 0:40 |

---

## 1 — Cold open
**[ON SCREEN: diagram, empty AWS region]**

Every single thing you'll ever build in AWS lives inside a network you set up first. Not the fun part, I know — nobody got into the cloud because they were excited about route tables. But get this one wrong and nothing else works, so let's get it right once, in about eight minutes, and never think about it again.

By the end you'll have a real, working VPC — the private network your servers live in — spun up from a Terraform module, tested for free on your own machine. No AWS account, no bill.

## 2 — What we're building
**[ON SCREEN: diagram fills in — VPC box, two public subnets, two private subnets, an internet gateway]**

Here's the shape of it. One **VPC** — think of it as your own walled-off slice of the cloud. Inside it, **public subnets** for things that face the internet, and **private subnets** for things that shouldn't. An **internet gateway** is the one door to the outside world, and route tables decide who's allowed to use it.

That's the whole plot of networking, and this module builds all of it from a handful of inputs.

## 3 — Tour the module inputs
**[ON SCREEN: `modules/vpc/variables.tf`]**

Quick look at what it takes. You give it a `name`, a `cidr_block` — that's the range of IP addresses your network owns, `10.0.0.0/16` is a fine default — and the subnet ranges. The AZs are the physical data centers we spread across so one failure doesn't take you down.

One input to notice: `enable_nat_gateway`, and it's **off by default**. A NAT gateway is the one piece in here that costs real money — about thirty-two dollars a month even when it's doing absolutely nothing. So we leave it off until you actually need it, and I'll show you where that switch is.

## 4 — Wire it up
**[ON SCREEN: `examples/vpc-ministack/main.tf`]**

Calling a module is just this block. Point `source` at the module, pass your values, done. Notice the provider up top has these `test` credentials and a local endpoint — that's what tells Terraform "talk to MiniStack on my laptop, not real AWS." That's the trick that makes this free to practice.

## 5 — init and plan
**[ON SCREEN: terminal]**
**[RUN: `terraform init`]**

`terraform init` pulls down the AWS provider. Give it a second.

**[RUN: `terraform plan`]**

And `plan` is Terraform showing you its homework before it touches anything — every resource it's about to create, in green. A VPC, an internet gateway, four subnets, the route tables. Read the plan; it's the difference between confidence and hoping. Reading a plan turns debugging into a checklist instead of a séance.

## 6 — apply and verify
**[RUN: `terraform apply`]**

Type `yes`. Terraform builds it in order and prints the outputs — your VPC ID and subnet IDs, ready to hand to the next module.

**[ON SCREEN: outputs highlighted]**

That's a complete network. If this were real AWS, you'd see the exact same thing in the console — MiniStack is just standing in so you can break things safely first.

## 7 — Cost and cleanup
**[ON SCREEN: terminal]**

Real quick on money, because it's the thing everyone's nervous about. Everything you just built — the VPC, subnets, gateway, routes — is **free** on real AWS too; none of it bills by the hour. The only paid piece is that NAT gateway we left off. Flip `enable_nat_gateway` to `true` only when a private server genuinely needs to reach the internet.

**[RUN: `terraform destroy`]**

And when you're done poking at it, `terraform destroy` tears it all down. On MiniStack you can also just stop the container. Either way, clean slate.

## 8 — Outro
**[ON SCREEN: diagram, then the repo README]**

That's your foundation. Every other module in this pack — security groups, servers, storage — snaps on top of this VPC. The code's linked below, it's free and MIT-licensed, and if you want the next lessons as they drop plus the diagrams, the newsletter's the place. See you in the next one.

**[END CARD: repo link + newsletter CTA]**
