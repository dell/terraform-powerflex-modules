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

##########################################
# Install Powerflex Manager EXSi/vSphere
##########################################

module "vsphere_pfmp_installation" {
  # Here the source points to the a local instance of the submodule in the modules folder, if you have and instance of the modules folder locally.
  # source = "../../modules/vsphere_pfmp_installation"

  # Here is an example of a source that pulls from the registry
  source  = "dell/modules/powerflex//modules/vsphere_pfmp_installation"
  version = "x.x.x" // pull in the latest version like "1.2.0"

  # Required
  # Ip address of the ntp server
  ntp_ip = var.ntp_ip
  # Ip address of installer node
  installer_node_ip = var.installer_node_ip
  # Ip address of node 1
  node_1_ip = var.node_1_ip
  # Ip address of node 2
  node_2_ip = var.node_2_ip
  # Ip address of node 3
  node_3_ip = var.node_3_ip

  # Optional values which if not set have default values
  ## Username to all nodes default is 'delladmin'
  # username = var.username  # default is 'delladmin'
  ## Password to all nodes default is 'delladmin'
  # password = var.password  
  ## Local path where you are running terraform to the PFMP_Config.json
  # local_path_to_pfmp_config = var.local_path_to_pfmp_config  # default is './PFMP_Config.json'
  ## This is default on Powerflex 4.6 or greater
  # destination_path_to_set_pfmp_config = var.destination_path_to_set_pfmp_config  # default is '/opt/dell/pfmp/PFMP_Installer/config/PFMP_Config.json'
  ## To use this deployment as a co res deployment
  # use_co_res = true
}
