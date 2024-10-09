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
  description = "Azure resource name prefix."
}

variable "existing_resource_group" {
  type    = string
  default = null
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Location of the azure resources."
}

variable "enable_bastion" {
  type    = bool
  default = false
}

variable "enable_jumphost" {
  type    = bool
  default = false
}

variable "enable_sql_workload_vm" {
  type    = bool
  default = false
}

variable "cluster_node_count" {
  type    = number
  default = 5
}

variable "is_multi_az" {
  type    = bool
  default = false
}

variable "deployment_type" {
  type    = string
  default = "balanced"
}

variable "data_disk_size_gb" {
  type    = number
  default = 512
}

variable "data_disk_count" {
  type    = number
  default = 20
}

variable "data_disk_logical_sector_size" {
  type    = number
  default = 512
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
  description = "Azure VM login credential."
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
  description = "Azure VM SSH key pair."
}

variable "storage_instance_gallary_image" {
  type = object({
    name                = string
    image_name          = string
    gallery_name        = string
    resource_group_name = string
  })
  description = "PowerFlex storage instance image in local gallary."
  default     = null
}

variable "installer_gallary_image" {
  type = object({
    name                = string
    image_name          = string
    gallery_name        = string
    resource_group_name = string
  })
  description = "PowerFlex installer image in local gallary."
  default     = null
}
