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