# ============================================================
#  ansible_vars.tpl — Généré automatiquement par Terraform
#  Produit : ansible/group_vars/all.yml
# ============================================================

admin_user: "${admin_user}"
ssh_public_key: "${ssh_pub_key}"
gateway: "${gateway}"
dns_servers: ${jsonencode(dns)}

vm_configs:
%{ for name, vm in vms ~}
  ${name}:
    ip_address: "${vm.ip_address}"
    os: "${vm.os}"
    packages: ${jsonencode(vm.packages)}
    hardening: ${vm.hardening}
%{ endfor ~}