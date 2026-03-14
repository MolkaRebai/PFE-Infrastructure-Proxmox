#  Crée toutes les VMs définies dans vms.auto.tfvars

#Création de toutes les VMs
resource "proxmox_virtual_machine" "vms" {
  for_each = var.vms   # boucle sur chaque VM définie dans vms.auto.tfvars

  # Identité
  node_name = var.proxmox_node
  vm_id     = each.value.vm_id
  name      = each.key              # clé de la map = nom de la VM
  tags      = ["terraform", each.value.os]

  # Clone depuis le template correspondant à l'OS choisi
  clone {
    vm_id = var.os_templates[each.value.os]
    full  = true
  }

  # CPU
  cpu {
    cores   = each.value.cpu
    sockets = 1
    type    = "x86-64-v2-AES"
  }

  # RAM
  memory {
    dedicated = each.value.ram_mb
  }

  # Disque
  disk {
    interface    = "virtio0"
    size         = each.value.disk_gb
    datastore_id = var.default_storage
    discard      = "on"
  }

  # Réseau
  network_device {
    bridge = var.default_bridge
    model  = "virtio"
  }

  # Cloud-Init : configure IP + user au premier démarrage
  initialization {
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

  operating_system {
    type = var.type
  }

  started         = true
  on_boot         = true
  stop_on_destroy = true

  lifecycle {
    ignore_changes = [clone]
  }
}

#Génération automatique de l'inventory Ansible
# Crée le fichier inventory.ini après la création des VMs
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventory.ini"

  content = templatefile("${path.module}/inventory.tpl", {
    vms            = var.vms
    admin_user     = var.admin_user
    ssh_key_path   = var.ssh_private_key_path
  })

  depends_on = [proxmox_virtual_machine.vms]
}

#Génération des variables Ansible par VM
resource "local_file" "ansible_vars" {
  filename = "${path.module}/../ansible/group_vars/all.yml"

  content = templatefile("${path.module}/ansible_vars.tpl", {
    vms         = var.vms
    admin_user  = var.admin_user
    ssh_pub_key = var.ssh_public_key
    gateway     = var.default_gateway
    dns         = var.default_dns
  })

  depends_on = [proxmox_virtual_machine.vms]
}
