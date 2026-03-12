
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
    backup      = bool
  }))
}
```

`Ctrl+S` pour sauvegarder

---

## Étape 4 — Créer `lxc.tf`
```
Clic droit sur le dossier terraform
→ New File
→ Taper : lxc.tf
→ Entrée