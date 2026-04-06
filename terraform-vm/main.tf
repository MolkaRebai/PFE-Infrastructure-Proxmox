resource "proxmox_virtual_environment_vm" "vms" {
  for_each   = var.vms
  node_name  = var.proxmox_node
  vm_id      = each.value.vm_id
  name       = each.key
  tags       = ["terraform", each.value.os]

  clone {
    vm_id = var.os_templates[each.value.os]
    full  = true
  }

  cpu {
    cores   = each.value.cpu
    sockets = 1
    type    = "x86-64-v2-AES"
  }

  memory {
    dedicated = each.value.ram_mb
    floating  = 0
  }

  # ✅ Disque système — SATA pour Windows, VirtIO pour Linux
  dynamic "disk" {
    for_each = each.value.os_type == "win10" ? [1] : []
    content {
      interface    = "sata0"
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

  # ✅ Boot order — SATA pour Windows, VirtIO pour Linux
  boot_order = each.value.os_type == "win10" ? ["sata0"] : ["virtio0"]

  # ✅ CD-ROM VirtIO — Windows uniquement
  dynamic "cdrom" {
    for_each = each.value.os_type == "win10" ? [1] : []
    content {
      file_id   = "NAS-ISO:iso/virtio-win.iso"
      interface = "sata1"
    }
  }

  # ✅ CD-ROM Veeam — uniquement pour la VM Veeam
  dynamic "cdrom" {
    for_each = each.value.os == "windows-server-22" ? [1] : []
    content {
      file_id   = "NAS-ISO:iso/VeeamBackup&Replication_13.0.1.2067_20260310.iso"
      interface = "sata2"
    }
  }

  network_device {
    bridge  = var.default_bridge
    model   = "virtio"
  }

  # ✅ Cloud-Init — Linux uniquement
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