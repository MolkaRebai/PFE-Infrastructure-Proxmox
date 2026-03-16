# Connexion Proxmox
proxmox_url       = "https://172.19.14.90:8006/"
proxmox_api_token = "root@pam!terraform=3cd48795-cbc6-43e3-a613-0a7c512b12d2"
proxmox_node      = "pve"

#Stockage NAS
storage_vm     = "nas-vm"
storage_iso    = "nas-iso"
storage_backup = "nas-backup"

#Réseau
default_gateway = "172.19.14.1"
default_dns     = ["172.19.14.1", "8.8.8.8"]
default_bridge  = "vmbr0"

#Admin
admin_user           = "sysadmin"
ssh_public_key       = "ssh-rsa AAAAB3NZaC1YC2EAAAADAQABAAACAQCCiFisaP3gtX2d9Q06dy2kbh5xw1byAsmEbWekC1bhpJaLTOFTxurBumX03JaGBwwA03zuUZG1VJYhoFzx72ukaNoyw+LTnG9oT11DQBvTV+bfPMyQ706se644 OceC1XXjfPsqyTdEG/Jujmk TJNKz14du1r4DQjLa3BF41GFXcydqLLagyan01oBNtowedrw/uIKtb15PLCF27W/bvL62NI76vBKEFhFV1kMSTyL1eYpS10kFgAQEqaM8uxHmH7M6T6pnAokujq5JJiqQS12f1gGQEqrwzhxGq1/iYhH21bS510o77a7x04/JUdWpzNZsfW8SYyFh1q/u1vArHid75y6spf1FcokjVY1fQ4pmeWKWs1TKwgF4aGFNraL8R4017211++cf/Mjm1919elY+EaoXEBR1Fco6rpEJieLYG0TQqQ/p1g4oxk13Cr92MiVkkpHX1wSD9CBQzv2gN/FQEtIMrqMWSHoKFxW6f41CF971YID0KFcDm3arbPQfotcHX612xGxBfS2eHEIK6311Cfyfbj3c0ivF80YIC8dutWg5sBcsX3+CDPw/gSex75vKRkm5ES+fRp+csp29MAczT7puRYSYrVJw/p7uSv@uzumVnUC/JU600L8G7PQWD/NRDxEp62h6k4rVS72qBLNYLTCKKzGZLT+XfFluecBWYw== admine@admin"
ssh_private_key_path = "/home/ubuntu/.ssh/id_rsa"

# Templates OS
os_templates = {

  # Linux Desktop
  

  # Linux Server
  "ubuntu-server-22-04"  = 9000
  

  # Windows
  "windows-server-22" = 9020 
  

}