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

resource "null_resource" "sanitize_dir" {
  provisioner "local-exec" {
    working_dir = "${path.module}"
    interpreter = var.interpreter
    command = <<-EOT
      export LANG=C.UTF-8
      find . -type f -name "*.sh" -exec dos2unix {} \;
      find . -type f -name "*.tf" -exec dos2unix {} \;
      dos2unix ./submodules/installer_api/main.tf
      dos2unix ./submodules/copy_installation_scripts/*.sh
      dos2unix ./submodules/reset_core_installation/*
      sleep 5
     EOT     
  }
}

module "copy-installation-scripts" {
  source              = "./submodules/copy_installation_scripts"
  co_res_ips          = var.co_res_ips
  host_ip             = var.installer_node_ip
  installer_ip        = var.installer_node_ip
  private_key_path    = var.private_key_path
  user                = var.install_node_user
  bastion_config      = var.bastion_config
}

module "get_hostnames" {
  source              = "./submodules/get_hostnames_script"
  bastion_config      = var.bastion_config
  management_ips      = var.management_ips
  host_ip             = var.installer_node_ip
  user                = var.generated_username
  private_key_path    = var.private_key_path
  interpreter         = var.interpreter
}

# Copy the PFMP config to the installer vm


module "prepare-installer-api" {
  source                         = "./submodules/installer_api"
  co_res_ips                     = var.co_res_ips
  installer_ip                   = var.installer_node_ip
  private_key                    = var.private_key_path
  management_ips                 = var.management_ips
  generated_username             = var.generated_username
  loadbalancer_dns               = var.loadbalancer_dns
  loadbalancer_ip               = var.loadbalancer_ip
  
  interpreter                    = var.interpreter
  device_mapping                 = slice(var.device_mapping, 0, var.number_of_disks)
  instance_type                  = var.instance_type
  timestamp                      = local.timestamp
  multi_az                       = var.multi_az
  hostnames                      = module.get_hostnames.hostnames
  depends_on                     = [module.get_hostnames]
}

module "execute-installer-api" {
  source                         = "./submodules/execute_installer_api"
  bastion_config      = var.bastion_config
  interpreter                    = var.interpreter
  executer_location = module.prepare-installer-api.output_directory
  depends_on = [module.prepare-installer-api]
}

module "remove-on-destroy" {
  source              = "./submodules/remove_on_destroy"
  files_to_remove     = concat([module.prepare-installer-api.output_directory],["/tmp/hostnames_output.txt"])
  bastion_config      = var.bastion_config
}
