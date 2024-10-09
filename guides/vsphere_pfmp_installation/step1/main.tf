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
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.8.2"
    }
  }
}

provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = var.allow_unverified_ssl
  api_timeout          = 10
}

################################################################################
# Deploy vSphere OVA Virtual Machines for Powerflex Manager Installer and Nodes
################################################################################

# Steps to use:
# 1. Run `terraform init`
# 2. Fill in the `input.tfvars` with your information and do a `terraform apply --var-file=input.tfvars`
# For more information about this step check guides/vsphere_pfmp_installation/README.md 

# Deploy the installer node 
module "vsphere_ova_vm_deployment_installer" {
  # Here source points to the vsphere-ova-vm-deployment submodule in the modules folder. You can change the value to point it according to your usecase. 
  source = "../../../modules/vsphere-ova-vm-deployment"

  # Required
  vm_ova_path = var.pfmp_installer_ova_local_path
  vsphere_datacenter_name = var.vsphere_datacenter_name
  vsphere_datastore_name = var.vsphere_datastore_name
  vsphere_network_name = var.vsphere_network_name
  vsphere_host_name = var.vsphere_host_name
  vsphere_resource_pool_name = var.vsphere_resource_pool_name

  # Optional values which if not set have default values
  vm_name = "pfmp-installer-node"
  # You can set this to false or comment out if you are using a link to an ova instead of on your local file
  use_remote_path = true
  # Recommended number of CPUs according to Powerflex
  num_cpus = 14
  # Recommended memory according to Powerflex
  memory = 32480
}

# Deploy node 1
module "vsphere_ova_vm_deployment_node_1" {
  # Here source points to the vsphere-ova-vm-deployment submodule in the modules folder. You can change the value to point it according to your usecase. 
  source = "../../../modules/vsphere-ova-vm-deployment"

  # Required
  vm_ova_path = var.pfmp_node_ova_local_path
  vsphere_datacenter_name = var.vsphere_datacenter_name
  vsphere_datastore_name = var.vsphere_datastore_name
  vsphere_network_name = var.vsphere_network_name
  vsphere_host_name = var.vsphere_host_name
  vsphere_resource_pool_name = var.vsphere_resource_pool_name

  vm_name = "pfmp-node-1"
  # You can set this to false or comment out if you are using a link to an ova instead of on your local file
  use_remote_path = true
  # Recommended number of CPUs according to Powerflex
  num_cpus = 14
  # Recommended memory according to Powerflex
  memory = 32480
}

# Deploy node 2
module "vsphere_ova_vm_deployment_node_2" {
  # Here source points to the vsphere-ova-vm-deployment submodule in the modules folder. You can change the value to point it according to your usecase. 
  source = "../../../modules/vsphere-ova-vm-deployment"

  # Required
  vm_ova_path = var.pfmp_node_ova_local_path
  vsphere_datacenter_name = var.vsphere_datacenter_name
  vsphere_datastore_name = var.vsphere_datastore_name
  vsphere_network_name = var.vsphere_network_name
  vsphere_host_name = var.vsphere_host_name
  vsphere_resource_pool_name = var.vsphere_resource_pool_name

  vm_name = "pfmp-node-2"
  # You can set this to false or comment out if you are using a link to an ova instead of on your local file
  use_remote_path = true
  # Recommended number of CPUs according to Powerflex
  num_cpus = 14
  # Recommended memory according to Powerflex
  memory = 32480
}

# Deploy node 3
module "vsphere_ova_vm_deployment_node_3" {
  # Here source points to the vsphere-ova-vm-deployment submodule in the modules folder. You can change the value to point it according to your usecase. 
  source = "../../../modules/vsphere-ova-vm-deployment"

  # Required
  vm_ova_path = var.pfmp_node_ova_local_path
  vsphere_datacenter_name = var.vsphere_datacenter_name
  vsphere_datastore_name = var.vsphere_datastore_name
  vsphere_network_name = var.vsphere_network_name
  vsphere_host_name = var.vsphere_host_name
  vsphere_resource_pool_name = var.vsphere_resource_pool_name


  # Optional values which if not set have default values
  vm_name = "pfmp-node-3"
  # You can set this to false or comment out if you are using a link to an ova instead of on your local file
  use_remote_path = true
  # Recommended number of CPUs according to Powerflex
  num_cpus = 14
  # Recommended memory according to Powerflex
  memory = 32480
}
