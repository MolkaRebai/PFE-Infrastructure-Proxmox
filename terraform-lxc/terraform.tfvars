# Connexion Proxmox
proxmox_url       = "https://172.19.14.90:8006/"
proxmox_api_token = "root@pam!terraform=3cd48795-cbc6-43e3-a613-0a7c512b12d2"
proxmox_node      = "pve"

# Stockage NAS
storage_vm     = "NAS-VM"
storage_iso    = "NAS-ISO"
storage_backup = "NAS-BACKUP"

# Réseau
default_gateway = "172.19.14.1"
default_dns     = ["172.19.14.1", "8.8.8.8"]
default_bridge  = "vmbr0"

# LXC
lxc_root_password    = "admin@2026"
lxc_template_default = "NAS-ISO:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"