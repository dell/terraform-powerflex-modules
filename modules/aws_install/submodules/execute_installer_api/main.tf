# /*
# Copyright (c) 2024 Dell Inc., or its subsidiaries. All Rights Reserved.

# Licensed under the Mozilla Public License Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://mozilla.org/MPL/2.0/


# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# */

variable "bastion_config" {
  description = "Bastion configuration"
  type = object({
    use_bastion    = bool
    bastion_host   = string
    bastion_user   = string
    bastion_ssh_key = string
  })
  default = {
    use_bastion    = false
    bastion_host   = null
    bastion_user   = "root"
    bastion_ssh_key = "~/.ssh/id_rsa.pem"
  }
}

variable "executer_location" {
  type = string
  description = "the path to the reset core directory location"
}  

variable "interpreter" {
  type = list(string)
  description = "the interpreter of this script"
}

locals {
    relative_path = "../.."
}

resource "null_resource" "copy_executer" {
  count = var.bastion_config.use_bastion ? 1 : 0
  provisioner "local-exec" {
    when    = create 
    working_dir = "${path.module}"
    interpreter = var.interpreter
    command = <<-EOT
      echo 'Running local provisioner'
      scp -o 'StrictHostKeyChecking no' -i ${var.bastion_config.bastion_ssh_key}  ${local.relative_path}/${var.executer_location}/run_installer.sh  ${var.bastion_config.bastion_user}@${var.bastion_config.bastion_host}:/tmp/.
      scp -o 'StrictHostKeyChecking no' -i ${var.bastion_config.bastion_ssh_key}  ${local.relative_path}/${var.executer_location}/Rest_Config.json  ${var.bastion_config.bastion_user}@${var.bastion_config.bastion_host}:/tmp/.
    EOT
  }
}

resource "null_resource" "installer_executer_local" {
  count = var.bastion_config.use_bastion ? 0 : 1
  provisioner "local-exec" {
    when    =  create
    working_dir = "${path.module}"
    interpreter = var.interpreter
     command = <<-EOT
      echo 'Running local provisioner'
      cd ${local.relative_path}/${var.executer_location}; chmod +x ./run_installer.sh
      cd ${local.relative_path}/${var.executer_location}; ./run_installer.sh
     EOT
  }
}

resource "null_resource" "installer_executer_remote" {
  count = var.bastion_config.use_bastion ? 1 : 0
  provisioner "remote-exec" {
    when       = create
    inline     = [
      "echo 'Running on bastion host'",
      "sleep 10",
      " cd /tmp; dos2unix ./run_installer.sh; dos2unix ./Rest_Config.json;",
      " cd /tmp; chmod +x ./run_installer.sh; ./run_installer.sh;"
    ]
    connection {
      type        = "ssh"
      user        = var.bastion_config.bastion_user
      private_key = file(var.bastion_config.bastion_ssh_key)
      host        = var.bastion_config.bastion_host
    }
  }

  #provisioner "remote-exec" {
  #  when       = "destroy"
  #  inline     = [
  #    " cd /tmp; rm ./run_installer.sh; rm ./Rest_Config.json;"
  #  ]
  #  connection {
  #    type        = "ssh"
  #    user        = var.bastion_config.bastion_user
  #    private_key = file(var.bastion_config.bastion_ssh_key)
  #    host        = var.bastion_config.bastion_host
  #  }
  #}
}
