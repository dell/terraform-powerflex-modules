variable "files_to_remove" {
  type = list(string)
  description = "the files array to remove on destroy"
}

variable "bastion_config" {
  description = "Bastion configuration"
  type = object({
    use_bastion    = bool
    bastion_host   = string
    bastion_user   = string
    bastion_ssh_key = string
  })
}

resource "null_resource" "remove_on_destroy" {
  triggers = {
    files_to_remove = join(" ",var.files_to_remove)
  }
  provisioner "local-exec" {
    command = "rm -rf  ${self.triggers.files_to_remove}"
    when    = destroy
  }
}
resource "terraform_data" "delete_remote_files" {
  input = {
     user        = var.bastion_config.bastion_user
     private_key = var.bastion_config.bastion_ssh_key
     host        = var.bastion_config.bastion_host
  }
  provisioner "remote-exec" {
    when       = destroy
    inline     = [
      " cd /tmp; rm -f ./run_installer.sh; rm -f ./Rest_Config.json; rm -f ./terraform_*.sh"

    ]
    connection {
      type        = "ssh"
      user        = self.output.user
      private_key = file(self.output.private_key)
      host        = self.output.host
    }
  }
}

#resource "null_resource" "remove_files_remote" {
#  count = var.bastion_config.use_bastion ? 1 : 0
#  triggers = {
#    always_run = timestamp()
#  }
#  connection {
#    type        = "ssh"
#    user        = var.bastion_config.bastion_user
#    private_key = file(var.bastion_config.bastion_ssh_key)
#    host        = var.bastion_config.bastion_host
#  }
 
#  provisioner "remote-exec" {
#    when       = destroy
#    inline     = [
#      "cd /tmp; rm ./Rest_Config.json; rm ./run_installer.sh;"
#    ]
#  }
#}