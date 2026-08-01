# Fully Automated, Highly Available Infrastructure on Proxmox VE

A final-year project (PFE) at Prologic Tunisie: a two-node Proxmox VE cluster
where a single `git push` provisions VMs and LXC containers, configures them
with Ansible, monitors them with Zabbix, and reports on them weekly — with
no manual intervention.

📖 Full write-up (problem, test results, honest limitations):
[molkarebai.github.io](https://molkarebai.github.io/proxmox-infrastructure.html)

---

## Architecture

```
                    ┌──────────────────────────────┐
                    │   Team & DevOps Tooling       │
                    │  GitHub Actions → Terraform    │
                    │           + Ansible            │
                    └───────────────┬──────────────┘
                                    │ IaC deployment
                    ┌───────────────▼──────────────────────────┐
                    │        Proxmox VE Cluster (HA)             │
                    │  ┌────────────────┐   ┌──────────────────┐ │
                    │  │ Host 1 (ACTIVE)│◄─►│ Host 2 (STANDBY) │ │
                    │  │ Windows/Linux   │   │ ready for auto-  │ │
                    │  │ VMs · LXC       │   │ failover restart │ │
                    │  │ Veeam · Zabbix  │   │                  │ │
                    │  └───────┬────────┘   └────────┬─────────┘ │
                    └──────────┼─────────────────────┼───────────┘
                          Switch 1 ◄── redundant ──► Switch 2
                                    │             │
                              Shared storage (NFS / ZFS over iSCSI)
```

Two physical hosts form the Proxmox VE cluster. Host 1 runs the active
workload (Windows AD/WDS, Linux services, LXC containers, Veeam, Zabbix);
Host 2 stands by for automatic HA failover. Both hosts connect to redundant
switches and shared NFS/ZFS storage, which is what makes live migration and
failover possible in the first place.

---

## CI/CD pipeline

Everything is driven by GitHub Actions across five workflow stages:

```
Trigger → Validate → Deploy → Configure → Resource Management → Weekly Report
                                    │
                                    └──► Notify (Slack/email, on success or failure)
```

### 1 · Trigger
- Push to `main`, `develop`, or a feature branch
- Pull request
- Manual `workflow_dispatch`

### 2 · Validate (`validate.yml`)
Runs in parallel, before anything touches real infrastructure:
- **Terraform VM** — `terraform fmt -check`, `terraform validate` on `terraform-vm/`
- **Terraform LXC** — same checks on `terraform-lxc/`
- **Ansible** — `ansible-lint`, `ansible-playbook --syntax-check` on `ansible/playbooks/`

### 3 · Deploy (`deploy.yml`)
Split into plan/apply, gated by event type:

| Job | Trigger | Action |
|---|---|---|
| `plan-vm` | Pull request | `terraform plan` on `terraform-vm/`, comments the PR |
| `plan-lxc` | Pull request | `terraform plan` on `terraform-lxc/`, comments the PR |
| `apply-vm` | Push to `main` | `terraform apply -auto-approve`, generates `ansible/inventory.ini` |
| `apply-lxc` | Push to `main`, needs `apply-vm` | `terraform apply -auto-approve` for containers |

Secrets (`PROXMOX_API_TOKEN`, `SSH_PUBLIC_KEY`, `PROXMOX_HOST`, `PROXMOX_NODE`,
and `TF_VAR_*`) are injected by GitHub Actions — nothing is committed to the repo.

**Terraform VM module** — one `for_each` over `var.vms`, branching by `os_type`:
- **Linux**: SeaBIOS, `virtio0` disk (`io_uring`, discard, backup), Cloud-Init
  enabled (IP/DNS/user/SSH key injected at boot)
- **Windows**: OVMF (UEFI) with TPM state v2.0, `ide0` disk, `virtio-win.iso`
  mounted for drivers, Cloud-Init disabled

**Terraform LXC module** — one `for_each` over `var.lxcs`: CPU/memory/disk/
network per container, hostname from the map key, optional custom template
(defaults to Ubuntu), and a `privileged` flag per container.

### 4 · Configure (`configure.yml`)
Runs only if deploy succeeded. Ansible playbook order:
1. `ping` — connectivity check against the fresh inventory
2. `setup_common.yml` — baseline packages/hardening
3. Role-specific playbooks — DNS · NFS · Web · DB · App
4. `setup_zabbix_agents.yml` — installs and registers the Zabbix agent on every host

### 5 · Resource management (post-deploy)
Zabbix watches CPU/RAM/uptime on every node. A load threshold breach fires a
`repository_dispatch` back into GitHub Actions, which resizes the affected
VM's CPU/RAM via the same Terraform-backed pipeline — closing the loop without
a human touching the console.

### 6 · Weekly report (`weekly-report.yml`)
A scheduled job (`0 8 * * 1` — every Monday) plus manual dispatch:
1. Checks out the repo, installs `requests` + `jinja2`
2. `weekly_report.py` queries the **Zabbix API** (`user.login`, `problem.get`
   over 7 days, `host.get` for VM status, `item.get` for metrics) and the
   **Proxmox API** (node status, CPU/memory usage, uptime) over HTTPS
3. Aggregates VM stats, parses problem severities, computes the weekly window
4. Renders an HTML dashboard via Jinja2 (summary, node table, VM status,
   problem log) to `/tmp/weekly_report.html`
5. Uploads it as a GitHub Actions artifact (`weekly-report-${run_number}`,
   30-day retention)

### 7 · Notify (`notify.yml`)
Triggered by `workflow_run` → `completed` on any of the above. Reads the
triggering workflow's name, branch, actor, and conclusion, then:
- **Success** → Slack/email notification + GitHub Step Summary
- **Failure** → Slack/email notification with error-log URL + GitHub Step Summary

Every run — pass or fail — ends up traceable in the GitHub Step Summary:
workflow status, branch/user, logs URL, and pipeline execution details.

---

## Repository structure

```
.github/workflows/     validate.yml · deploy.yml · configure.yml
                        weekly-report.yml · notify.yml
terraform-vm/           VM provisioning module (Linux + Windows)
terraform-lxc/          LXC container provisioning module
terraform/               shared/root Terraform config
ansible/                 playbooks + generated inventory.ini
```

---

## Stack

Proxmox VE · Terraform · Ansible · GitHub Actions · Zabbix · Veeam Backup &
Replication · pfSense · Python (Jinja2, requests)

---

## Full write-up

The [portfolio write-up](https://molkarebai.github.io/proxmox-infrastructure.html)
covers the actual validation done on this infrastructure — a hard node kill
to test HA failover, a `stress-ng`-driven auto-scaling test, and a full
disaster-recovery restore of a deleted 160 GB VM — plus an honest section on
what's still a lab simplification (a flatter management network than the
VLAN diagram implies, and a few other caveats) rather than a finished,
production-hardened deployment.

---

*Completed with Imen Ferchichi at Prologic Tunisie, under the supervision of
Mohamed Kheiridine Zarkouna (Prologic) and Issa Chihaoui (ISTIC).*
