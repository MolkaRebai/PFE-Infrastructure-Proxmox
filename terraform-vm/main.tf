# ── Création de toutes les VMs ────────────────────────────────────────────────
resource "proxmox_virtual_environment_vm" "vms" {
  for_each = var.vms   # boucle sur chaque VM définie dans vms.auto.tfvars
  # Empêche les clones parallèles
  depends_on = []
  # Identité
resource "proxmox_virtual_environment_vm" "vms" {
  for_each  = var.vms
  node_name = var.proxmox_node
  vm_id     = each.value.vm_id
  name      = each.key
  tags      = ["terraform", each.value.os]

  clone {
    vm_id = var.os_templates[each.value.os]
    full  = true
  }

  #UEFI — Windows uniquement
  bios = each.value.os_type == "win10" ? "ovmf" : "seabios"

  dynamic "efi_disk" {
    for_each = each.value.os_type == "win10" ? [1] : []
    content {
      datastore_id = var.storage_vm
      file_format  = "raw"
      type         = "4m"
    }
  }

  dynamic "tpm_state" {
    for_each = each.value.os_type == "win10" ? [1] : []
    content {
      datastore_id = var.storage_vm
      version      = "v2.0"
    }
  }

  cpu {
    cores   = each.value.cpu
    sockets = 1
    type    = "kvm64"
  }

  memory {
    dedicated = each.value.ram_mb
    floating  = 0
  }

  # Disque — IDE pour Windows, VirtIO pour Linux
  dynamic "disk" {
    for_each = each.value.os_type == "win10" ? [1] : []
    content {
      interface    = "ide0"
      size         = each.value.disk_gb
      datastore_id = var.storage_vm
      file_format  = "raw"
    }
  }

  dynamic "disk" {
    for_each = each.value.os_type == "l26" ? [1] : []
    content {
      interface    = "virtio0"
      size         = each.value.disk_gb
      datastore_id = var.storage_vm
      file_format  = "raw"
      cache        = "none"
      aio          = "io_uring"
      discard      = "ignore"
      backup       = true
      replicate    = true
    }
  }

  #Boot order corrigé — ide0 pour Windows, virtio0 pour Linux
  boot_order = each.value.os_type == "win10" ? ["ide0"] : ["virtio0"]

  #CD-ROM VirtIO — Windows uniquement
  dynamic "cdrom" {
    for_each = each.value.os_type == "win10" ? [1] : []
    content {
      file_id   = "NAS-ISO:iso/virtio-win.iso"
      interface = "ide1"
    }
  }

  #Réseau
  network_device {
    bridge = var.default_bridge
    model  = "virtio"
  }

  #Cloud-Init — Linux uniquement
  dynamic "initialization" {
    for_each = each.value.os_type == "l26" ? [1] : []
    content {
      ip_config {
        ipv4 {
          address = "${each.value.ip_address}/${each.value.prefix}"
          gateway = var.default_gateway
        }
      }
      dns {
        servers = var.default_dns
      }
      user_account {
        username = var.admin_user
        keys     = [var.ssh_public_key]
      }
    }
  }

  #OS type dynamique
  operating_system {
    type = each.value.os_type
  }

  started         = true
  on_boot         = true
  stop_on_destroy = true

  lifecycle {
    ignore_changes = [clone]
  }
}
