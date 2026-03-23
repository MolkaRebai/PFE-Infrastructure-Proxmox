variable "proxmox_url" {
  description = "URL de Proxmox"
  type        = string
}

variable "proxmox_api_token" {
  description = "Token API"
  type        = string
  sensitive   = true
}

variable "proxmox_node" {
  description = "Nom du noeud"
  type        = string
  default     = "pve"
}
#Stockage NAS
variable "storage_vm" {
  description = "Stockage NAS pour les disques des VMs"
  type        = string
  default     = "nas-vm"
}

variable "storage_iso" {
  description = "Stockage NAS pour les ISOs"
  type        = string
  default     = "nas-iso"
}

variable "storage_backup" {
  description = "Stockage NAS pour les backups"
  type        = string
  default     = "nas-backup"
}

#Réseau
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

#Admin
variable "admin_user" {
  description = "Utilisateur admin créé sur chaque VM Linux"
  type        = string
  default     = "sysadmin"
}

variable "ssh_public_key" {
  description = "Clé SSH publique déployée sur chaque VM Linux"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Chemin clé SSH privée sur la VM d'automatisation"
  type        = string
}

#template OS
variable "os_templates" {
  description = "Table correspondance OS → ID template Proxmox"
  type        = map(number)
}

#mot de passe vm
variable "vm_password" {
  description = "Mot de passe des VMs Linux"
  type        = string
  sensitive   = true
    default     = "azerty123"

}

# Définition des VMs à créer
variable "vms" {
  description = "Map de toutes les VMs à créer"
  type = map(object({
    vm_id      = number       # ID unique dans Proxmox
    cpu        = number       # Nombre de vCPU
    ram_mb     = number       # RAM en MB
    disk_gb    = number       # Disque en GB
    ip_address = string       # IP fixe
    prefix     = string       # Masque réseau (ex: "24")
    os         = string       # Clé dans os_templates
    os_type    = string       # "l26" Linux | "win10" Windows
    packages   = list(string) # Paquets à installer (Linux)
    hardening  = bool         # Appliquer le hardening
  }))
}
