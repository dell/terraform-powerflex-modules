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

variable "prefix" {
  type        = string
  description = "Prefix for Azure resource names."
}

variable "existing_resource_group" {
  type        = string
  default     = null
  description = "Name of existing resource group to use. If not set, a new resource group will be created."
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Location for Azure resources."
}

variable "enable_bastion" {
  type        = bool
  default     = false
  description = "Enable bastion."
}

variable "enable_jumphost" {
  type        = bool
  default     = false
  description = "Enable jumphost."
}

variable "enable_sql_workload_vm" {
  type        = bool
  default     = false
  description = "Enable sql workload vm."
}

variable "cluster_node_count" {
  type        = number
  default     = 5
  description = "PowerFlex cluster node number."
}

variable "is_multi_az" {
  type        = bool
  default     = false
  description = "Whether to deploy the PowerFlex cluster in single or multiple availability zones."
}

variable "deployment_type" {
  type        = string
  default     = "balanced"
  description = "PowerFlex cluster deployment type, Possible values are: 'balanced', 'optimized_v1' or 'optimized_v2'."
}

variable "data_disk_count" {
  type        = number
  default     = 20
  description = "The number of data disks attached to each PowerFlex cluster node."
}

variable "data_disk_size_gb" {
  type        = number
  default     = 512
  description = "The size of each data disk in GB."
}

variable "data_disk_logical_sector_size" {
  type        = number
  default     = 512
  description = "Logical Sector Size. Possible values are: 512 and 4096."
}

variable "login_credential" {
  type = object({
    username = string
    password = string
  })
  sensitive = true
  default = {
    username = "pflexuser"
    password = "PowerFlex123!"
  }
  description = "Login credential for Azure VMs."
}

variable "ssh_key" {
  type = object({
    public  = string
    private = string
  })
  default = {
    public  = "./ssh/azure.pem.pub"
    private = "./ssh/azure.pem"
  }
  description = "SSH key pair for Azure VMs."
}

variable "storage_instance_gallary_image" {
  type = object({
    name                = string
    image_name          = string
    gallery_name        = string
    resource_group_name = string
  })
  default     = null
  description = "PowerFlex storage instance image in local gallary. If set, the storage instance vm will be created from this image."
}

variable "installer_gallary_image" {
  type = object({
    name                = string
    image_name          = string
    gallery_name        = string
    resource_group_name = string
  })
  default     = null
  description = "PowerFlex installer image in local gallary. If set, the installer vm will be created from this image."
}

variable "vnet_address_space" {
  type        = string
  default     = "10.2.0.0/16"
  description = "Virtual network address space."
}

variable "subnets" {
  type = list(object({
    name   = string
    prefix = string
  }))
  default = [{
    name   = "BlockStorageSubnet"
    prefix = "10.2.0.0/24"
  }]
  description = "List of subnets for the virtual network."
}

variable "bastion_subnet" {
  type = object({
    name   = string
    prefix = string
  })
  default = {
    name   = "AzureBastionSubnet"
    prefix = "10.2.1.0/26"
  }
  description = "Bastion subnet."
}

variable "pfmp_lb_ip" {
  default     = "10.2.0.200"
  description = "Load balancer IP for PFMP service."
}
