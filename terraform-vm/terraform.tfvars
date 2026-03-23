# Connexion Proxmox
proxmox_url       = "https://172.19.14.90:8006/"
proxmox_api_token = "root@pam!terraform=3cd48795-cbc6-43e3-a613-0a7c512b12d2"
proxmox_node      = "pve"

#Stockage NAS
storage_vm     = "NAS-VM"
storage_iso    = "NAS-ISO"
storage_backup = "NAS-BACKUP"

#Réseau
default_gateway = "172.19.14.1"
default_dns     = ["172.19.14.1", "8.8.8.8"]
default_bridge  = "vmbr0"

#Admin
admin_user           = "sysadmin"
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCCiFisaP3gtX2d9Q06dy2Kbh5xw1byAsmEbWekClbhpJaLTOFTxurBumX03JaGBwwA03zuUZGlVJYhoFzx72ukaNoyw+LTnG9oT11DQBvTV+bfPMyQ706se644OceClXXjfPsqyTdEG/JujmkTJNKzi4du1r4DQjLa38F4IGFXcydqLLagyan0loBNtowedrW/uIKtb15PLCFz7W/bvL6ZNI76vBKEFhFV1kMSTyLieYpSi0kFgAQEqaM8uxHmH7M6T6pnAokujq5JJiqQSi2flgGQEqrwzhxGq1/iYhH21bS51Oo77a7xo4/JUdWpzNZsfW8SYyFh1q/u1vArHid75y6spflFcokjVY1fQ4pmeWKWsiTKwgF4aGFNraL8R4oi7Zii++cf/Mjml919elY+EaoXEBRlFco6rpEJieLYGOTQqQ/plg4oxk13Cr92MiVkkpHXlwSD9CBQzvZgN/FQEtIMrqMWsWoKFxW6f4lCF97lYID0KFcDm3arbPQfotcHX6i2xGxBfS2eHEIK63llCfyfbj3c0ivF80YIC8dutWg5sBcsX3+CDPw/gSex75vKRkm5ES+fRp+cspz9MAczT7puRYSYrVJw/p7uSv0uzumVnUC/JU6oOL8G7PQwD/NRDxEp62h6k4rVS72qBLNYLTCKKzGzLT+XfFluecBWYw== admine@admin"
ssh_private_key_path = "/home/ubuntu/.ssh/id_rsa"

#password generale pour les vm
vm_password = "azerty123"

# Templates OS
os_templates = {

  # Linux Desktop
  

  # Linux Server
  "ubuntu-server-22-04"  = 9000
  

  # Windows
  "windows-server-22" = 9020 
  

}