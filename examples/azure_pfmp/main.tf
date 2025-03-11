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

module "azure_pfmp" {
  # Here the source points to the a local instance of the submodule in the modules folder, if you have and instance of the modules folder locally.
  # source         = "../../modules/azure_pfmp"

  source  = "dell/modules/powerflex//modules/azure_pfmp"
  version = "x.x.x" // pull in the latest version like "1.2.0"

  bastion_subnet = var.bastion_subnet
  cluster = {
    node_count        = var.cluster_node_count
    is_multi_az       = var.is_multi_az
    deployment_type   = var.deployment_type
    data_disk_count   = var.data_disk_count
    data_disk_size_gb = var.data_disk_size_gb
  }
  data_disk_logical_sector_size  = var.data_disk_logical_sector_size
  enable_bastion                 = var.enable_bastion
  enable_jumphost                = var.enable_jumphost
  enable_sql_workload_vm         = var.enable_sql_workload_vm
  existing_resource_group        = var.existing_resource_group
  installer_gallary_image        = var.installer_gallary_image
  location                       = var.location
  login_credential               = var.login_credential
  pfmp_lb_ip                     = var.pfmp_lb_ip
  prefix                         = var.prefix
  ssh_key                        = var.ssh_key
  storage_instance_gallary_image = var.storage_instance_gallary_image
  subnets                        = var.subnets
  vnet_address_space             = var.vnet_address_space
}

output "bastion_tunnel" {
  value = module.azure_pfmp.bastion_tunnel != null ? "az network bastion tunnel --name ${module.azure_pfmp.bastion_tunnel.bastion_name} --resource-group ${module.azure_pfmp.bastion_tunnel.resource_group} --target-resource-id ${module.azure_pfmp.bastion_tunnel.installer_id} --resource-port 22 --port 1111" : null
}

output "pfmp_ip" {
  value = module.azure_pfmp.pfmp_ip
}

output "sds_nodes" {
  value = module.azure_pfmp.sds_nodes[*].ip
}
