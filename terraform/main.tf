
terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.60"
    }
  }
  required_version = ">= 1.5.0"
}

provider "proxmox" {
  endpoint  = var.proxmox_api_url
  api_token = "${var.proxmox_api_token_id}=${var.proxmox_api_token_secret}"
  insecure  = true  # Mettre false si certificat SSL valide
}

resource "proxmox_virtual_machine" "vm" {
  node_name = var.proxmox_node
  vm_id     = var.proxmox_vm_id
  name      = var.hostname
  tags      = ["terraform", var.os_template]

  clone {
    vm_id = var.proxmox_template_id
    full  = true
  }

  cpu {
    cores   = var.cpu
    sockets = 1
    type    = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.ram_mb
  }

  disk {
    interface    = "virtio0"
    size         = var.disk_gb
    datastore_id = var.proxmox_storage
  }

  network_device {
    bridge = var.proxmox_bridge
    model  = "virtio"
  }

  # Cloud-Init
  initialization {
    ip_config {
      ipv4 {
        address = "${var.ip_address}/${var.prefix_length}"
        gateway = var.gateway
      }
    }

    dns {
      servers = split(",", var.dns_servers)
    }

    user_account {
      username = var.admin_user
      keys     = [var.ssh_public_key]
    }
  }

  operating_system {
    type = each.value.os_type
  }

  # Attendre que la VM soit démarrée
  started         = true
  on_boot         = true
  stop_on_destroy = true

  lifecycle {
    ignore_changes = [clone]
  }
}
