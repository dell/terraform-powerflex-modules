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
  count = var.bastion_config.use_bastion ? 1 : 0
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
