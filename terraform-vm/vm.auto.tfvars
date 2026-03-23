# ============================================================
#  vm.auto.tfvars — Définition de toutes les VMs
#  os_type: "l26" = Linux | "win10" = Windows Server
# ============================================================

vms = {

  # ── Active Directory ────────────────────────────────────
  "vm-ad-01" = {
    vm_id      = 101
    cpu        = 4
    ram_mb     = 4096
    disk_gb    = 60
    ip_address = "172.19.14.15"
    prefix     = "24"
    os         = "windows-server-22"
    os_type    = "win10"
    packages   = []
    hardening  = false
  }

  # ── WDS ─────────────────────────────────────────────────
  "vm-wds-01" = {
    vm_id      = 102
    cpu        = 4
    ram_mb     = 4096
    disk_gb    = 100
    ip_address = "172.19.14.18"
    prefix     = "24"
    os         = "windows-server-22"
    os_type    = "win10"
    packages   = []
    hardening  = false
  }

  # ── Serveur Web ──────────────────────────────────────────
  "vm-web-01" = {
    vm_id      = 103
    cpu        = 2
    ram_mb     = 4096
    disk_gb    = 50
    ip_address = "172.19.14.20"
    prefix     = "24"
    os         = "ubuntu-server-22-04"
    os_type    = "l26"
    packages   = ["nginx", "curl", "vim"]
    hardening  = true
  }

  # ── Base de données ──────────────────────────────────────
  "vm-db-01" = {
    vm_id      = 104
    cpu        = 4
    ram_mb     = 8192
    disk_gb    = 100
    ip_address = "172.19.14.21"
    prefix     = "24"
    os         = "ubuntu-server-22-04"
    os_type    = "l26"
    packages   = ["postgresql", "vim"]
    hardening  = true
  }

  # ── Zabbix ───────────────────────────────────────────────
  "vm-zabbix-01" = {
    vm_id      = 105
    cpu        = 2
    ram_mb     = 4096
    disk_gb    = 50
    ip_address = "172.19.14.35"
    prefix     = "24"
    os         = "ubuntu-server-22-04"
    os_type    = "l26"
    packages   = ["curl", "vim"]
    hardening  = true
  }

  # ── Veeam ────────────────────────────────────────────────
  "vm-veeam-01" = {
    vm_id      = 106
    cpu        = 4
    ram_mb     = 8192
    disk_gb    = 200
    ip_address = "172.19.14.37"
    prefix     = "24"
    os         = "ubuntu-server-22-04"
    os_type    = "l26"
    packages   = ["curl", "vim"]
    hardening  = true
  }

}