lxcs = {

  # ── DNS Primaire ───────────────────────────────────────────
  "lxc-dns-1" = {
    lxc_id      = 200
    description = "Serveur DNS primaire - Pi-hole"
    cpu         = 1
    ram_mb      = 512
    swap_mb     = 256
    disk_gb     = 8
    ip_address  = "172.19.14.200"
    prefix      = "24"
    template    = ""
    privileged  = false
    start_boot  = true
    tags        = ["terraform", "lxc", "dns"]
    packages    = ["curl", "wget"]
  }

  # ── DNS Secondaire ─────────────────────────────────────────
  "lxc-dns-2" = {
    lxc_id      = 201
    description = "Serveur DNS secondaire - Pi-hole"
    cpu         = 1
    ram_mb      = 512
    swap_mb     = 256
    disk_gb     = 8
    ip_address  = "172.19.14.201"
    prefix      = "24"
    template    = ""
    privileged  = false
    start_boot  = true
    tags        = ["terraform", "lxc", "dns"]
    packages    = ["curl", "wget"]
  }

  # ── Base de données ────────────────────────────────────────
  "lxc-db" = {
    lxc_id      = 202
    description = "Base de données - PostgreSQL"
    cpu         = 2
    ram_mb      = 2048
    swap_mb     = 512
    disk_gb     = 30
    ip_address  = "172.19.14.202"
    prefix      = "24"
    template    = ""
    privileged  = false
    start_boot  = true
    tags        = ["terraform", "lxc", "db"]
    packages    = ["postgresql", "curl"]
  }

  # ── Application légère ─────────────────────────────────────
  "lxc-app" = {
    lxc_id      = 203
    description = "Application interne légère - Nginx"
    cpu         = 1
    ram_mb      = 512
    swap_mb     = 256
    disk_gb     = 10
    ip_address  = "172.19.14.203"
    prefix      = "24"
    template    = ""
    privileged  = false
    start_boot  = true
    tags        = ["terraform", "lxc", "app"]
    packages    = ["nginx", "curl"]
  }
# ── Serveur NFS ──────────────────────────────────────────
  "lxc-nfs" = {
    lxc_id      = 204
    description = "Serveur NFS - Partage fichiers interne"
    cpu         = 1
    ram_mb      = 512
    swap_mb     = 256
    disk_gb     = 50
    ip_address  = "172.19.14.204"
    prefix      = "24"
    template    = ""
    privileged  = true
    start_boot  = true
    tags        = ["terraform", "lxc", "nfs"]
    packages    = ["nfs-kernel-server", "curl"]
  }
}