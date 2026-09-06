# Recording script — terraform-aws-ec2-web

_Product: Terraform Module Packs · Module: `ec2-web` · Repo path: `modules/ec2-web`_
_Series tie-in: Cloud 101 / early AWS series · Est. runtime: 8–10 min · Lab: REAL AWS (Always-Free-tier friendly)_

**Find everything for this module:** Drive → 04 Products → Terraform Module Packs → `ec2-web` (`ec2-web-index.md` links the code, diagram, and thumbnail).

**Before you hit record**
- This one runs on **real AWS** — MiniStack doesn't fully emulate AMI lookups + instance launches. Use the dedicated sandbox account, budget alerts already set.
- Terminal open in `examples/ec2-web-basic`; AWS credentials for the sandbox exported
- Editor showing `modules/ec2-web/main.tf`
- A browser tab ready to hit the output URL

## Shot list

| # | Segment | On screen | ~time |
|---|---|---|---|
| 1 | Cold open | Diagram: VPC → SG → server → browser | 0:45 |
| 2 | What makes this "done right" | `main.tf` | 1:40 |
| 3 | Wire it up | `examples/ec2-web-basic/main.tf` | 1:00 |
| 4 | apply | terminal | 1:20 |
| 5 | The payoff | browser hitting the URL | 0:50 |
| 6 | Cost + DESTROY | terminal | 1:10 |
| 7 | Outro | diagram + repo | 0:40 |

---

## 1 — Cold open
**[ON SCREEN: diagram — VPC, security group, an EC2 instance, a browser arrow]**

This is the one that finally feels real. We're going to type `terraform apply` and, a minute later, open a browser and load an actual web page running on an actual server we just created. Everything so far — the network, the security group — has been foundation. This is the moment it turns into a thing you can point at.

Heads up: unlike the earlier modules, this one runs against **real AWS**, not MiniStack. It's still Always-Free-tier friendly, and I'll be very clear about tearing it down so it stays that way.

## 2 — What makes this "done right"
**[ON SCREEN: `modules/ec2-web/main.tf`]**

A lot of tutorials give you a server that works and quietly teaches you three bad habits. This module builds the same thing without them.

It finds the **latest Amazon Linux 2023 image automatically**, so you're never copy-pasting some stale AMI ID from a blog post. It enforces **IMDSv2** — that's the setting that blocks the classic attack where a hacked app tricks the server into handing over its cloud credentials. The root disk is **encrypted**. And SSH is **off by default** — because the number one way beginner servers get compromised is port 22 open to the whole internet.

It stands up its own security group, opens port 80 for the web, and runs a tiny script on boot to install a web server and drop a page. Real, but safe.

## 3 — Wire it up
**[ON SCREEN: `examples/ec2-web-basic/main.tf`]**

Watch how little this takes now that we have the building blocks. Spin up a VPC, then the server, handing it the VPC and a public subnet. Three modules, wired together, and the last line builds the URL from the server's public IP. That's the composition payoff — small pieces snapping together.

## 4 — apply
**[ON SCREEN: terminal]**
**[RUN: `terraform init && terraform apply`]**

Init, apply, `yes`. Terraform stands up the network, the security group, and the instance, then hands back the URL. The server needs a minute after this to finish installing the web server on boot — cloud-init doesn't care that we're impatient.

## 5 — The payoff
**[ON SCREEN: copy the `url` output → paste in browser → page loads]**

Give it a beat… and there it is. A live web page, on a server that didn't exist ninety seconds ago, defined entirely in code you can read, version, and rebuild identically tomorrow. That's the whole promise of infrastructure as code in one screen.

## 6 — Cost and DESTROY
**[ON SCREEN: terminal — say this part slowly]**

Now the important part, and I mean it. This is real AWS. A `t3.micro` is cheap, but "cheap" isn't "free forever," so we clean up.

**[RUN: `terraform destroy`]**

`yes`. Terraform removes everything it made — the instance, the security group, the network — in the right order. Confirm it's gone. Do this every single time you finish a session and surprise bills stop being a thing that happens to you.

## 7 — Outro
**[ON SCREEN: diagram, then repo]**

Four modules in, and you can build a real, secured, running web server from scratch and tear it down on command. Everything's linked below — free and MIT-licensed. The paid pack wires these into a full reference architecture; the newsletter's where it all shows up first. See you there.

**[END CARD: repo link + newsletter CTA]**
