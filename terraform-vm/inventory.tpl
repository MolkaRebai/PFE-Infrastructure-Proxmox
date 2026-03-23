# ============================================================
#  inventory.tpl — Généré automatiquement par Terraform
#  Produit : ansible/inventory/vms.ini
#  Contient uniquement les VMs Linux
# ============================================================

[vms]
%{ for name, vm in vms ~}
${name} ansible_host=${vm.ip_address}
%{ endfor ~}