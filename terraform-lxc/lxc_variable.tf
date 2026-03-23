
# Connexion Proxmox
variable "proxmox_url" {
  description = "URL de l'API Proxmox"
  type        = string
}

variable "proxmox_api_token" {
  description = "Token API Proxmox"
  type        = string
  sensitive   = true
}

variable "proxmox_node" {
  description = "Nom du noeud Proxmox"
  type        = string
  default     = "pve"
}

# Stockage NAS
variable "storage_vm" {
  description = "Stockage NAS pour les disques des LXC"
  type        = string
  default     = "NAS-VM"
}

variable "storage_iso" {
  description = "Stockage NAS pour les ISOs"
  type        = string
  default     = "NAS-ISO"
}

variable "storage_backup" {
  description = "Stockage NAS pour les backups"
  type        = string
  default     = "NAS-BACKUP"
}

# Réseau
variable "default_gateway" {
  description = "Passerelle réseau par défaut"
  type        = string
}

variable "default_dns" {
  description = "Serveurs DNS"
  type        = list(string)
  default     = ["8.8.8.8", "8.8.4.4"]
}

variable "default_bridge" {
  description = "Bridge réseau Proxmox"
  type        = string
  default     = "vmbr0"
}
variable "lxc_root_password" {
  description = "Mot de passe root des conteneurs LXC"
  type        = string
  sensitive   = true
}

variable "lxc_template_default" {
  description = "Template CT par défaut sur nas-iso"
  type        = string
  default     = "nas-iso:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
}

variable "lxcs" {
  description = "Map de tous les conteneurs LXC à créer"
  type = map(object({
    lxc_id      = number
    description = string
    cpu         = number
    ram_mb      = number
    swap_mb     = number
    disk_gb     = number
    ip_address  = string
    prefix      = string
    template    = string
    privileged  = bool
    start_boot  = bool
    tags        = list(string)
    packages    = list(string)
  }))
}