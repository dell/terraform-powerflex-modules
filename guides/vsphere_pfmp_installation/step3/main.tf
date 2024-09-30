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

terraform {
  required_providers {
    null = {  
      source = "hashicorp/null"  
      version = "3.2.1"  
    }
  }
}

##########################################
# Install Powerflex Manager EXSi/vSphere
##########################################

# Steps to use:
# 1. Run `terraform init`
# 2. Fill in the `input.tfvars` with your information and do a `terraform apply --var-file=input.tfvars`
# For more information about this step check guides/vsphere_pfmp_installation/README.md 

module "vsphere_pfmp_installation" {
  # Here source points to the vsphere_pfmp_installation submodule in the modules folder. You can change the value to point it according to your usecase. 
  source = "../../../modules/vsphere_pfmp_installation"

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
  # Do a co-res deployment of manager
  use_co_res = var.use_co_res
}
