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


variable "host_ip" {
  type = string
  description = "the host ip to run the script on"
}
variable "user" {
  type = string
  description = "the login username on the host"
}


variable "private_key_path" {
  type    = string
  default = "~/.ssh/id_rsa"
}

variable "reset_core_location" {
  type = string
  description = "the path to the reset core directory location"
  default = "../reset_core_installation"
}
variable "installer_ip" {
  type = string
  description = "the installer private ip"
}
variable "co_res_ips" {
  type = list(string)
  description = "the list of co-res private ips"
}

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

resource "null_resource" "copy-installation-scripts" {

  connection {
    type        = "ssh"
    host        = var.host_ip
    user        = var.user
    private_key = file(var.private_key_path)
    bastion_host        = var.bastion_config.use_bastion ? var.bastion_config.bastion_host : null
    bastion_user        = var.bastion_config.use_bastion ? var.bastion_config.bastion_user : null
    bastion_private_key = file(var.bastion_config.bastion_ssh_key)
  }

  provisioner "file" {
    source      = "${path.module}/${var.reset_core_location}"
    destination = "/tmp/reset-core-installation"
  }

  provisioner "remote-exec" {
     inline = [
      // create the post deployment directory in the installer
      "dos2unix /tmp/reset-core-installation/*",
      #var.installer_ip != "" ? "ssh -o 'StrictHostKeyChecking no' ${var.installer_ip} 'mkdir -p /tmp/bundle/post_deployment_scripts'" : "mkdir -p /tmp/bundle/post_deployment_scripts",
      "mkdir -p /tmp/bundle/post_deployment_scripts",
      "chmod +x /tmp/reset-core-installation/*",
      "cd /tmp/reset-core-installation && ./build-clean-core-mno.sh ${join(" ",var.co_res_ips)}",
      "cd /tmp/reset-core-installation && ./build-run-remote-script.sh ${join(" ",var.co_res_ips)}",
      #var.installer_ip != "" ? "scp -o 'StrictHostKeyChecking no' -r /tmp/reset-core-installation ${var.installer_ip}:/tmp/bundle/post_deployment_scripts/reset-core-installation" : "mv /tmp/reset-core-installation /tmp/bundle/post_deployment_scripts/reset-core-installation",
      "cp  -r /tmp/reset-core-installation /tmp/bundle/post_deployment_scripts/reset-core-installation",
      "rm -rf /tmp/reset-core-installation"
    ]

  }
}