output "lxc_info" {
  description = "Résumé des conteneurs LXC créés"
  value = {
    for name, lxc in proxmox_virtual_environment_container.lxc :
    name => {
      id         = lxc.vm_id
      ip         = var.lxcs[name].ip_address
      cpu        = var.lxcs[name].cpu
      ram_mb     = var.lxcs[name].ram_mb
      disk_gb    = var.lxcs[name].disk_gb
      backup     = var.lxcs[name].backup
      privileged = var.lxcs[name].privileged
    }
  }
}

#Outputs VMs
output "vm_info" {
  description = "Résumé des VMs créées"
  value = {
    for name, vm in proxmox_virtual_environment_vm.vm :
    name => {
      id  = vm.vm_id
      ip  = var.vms[name].ip_address
    }
  }
}