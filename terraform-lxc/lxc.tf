resource "proxmox_virtual_environment_container" "lxc" {
  for_each = var.lxcs

  node_name   = var.proxmox_node
  vm_id       = each.value.lxc_id
  description = each.value.description
  tags        = each.value.tags

  operating_system {
    template_file_id = (
      each.value.template != ""
      ? each.value.template
      : var.lxc_template_default
    )
    type = "ubuntu"
  }

  cpu {
    cores = each.value.cpu
  }

  memory {
    dedicated = each.value.ram_mb
    swap      = each.value.swap_mb
  }

  disk {
    datastore_id = var.storage_vm
    size         = each.value.disk_gb
  }

  network_interface {
    name   = "eth0"
    bridge = var.default_bridge
  }

  initialization {
    hostname = each.key

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
      password = var.lxc_root_password
    }
  }

  unprivileged  = !each.value.privileged
  started       = true
  start_on_boot = each.value.start_boot

  lifecycle {
    ignore_changes = [initialization]
  }
}