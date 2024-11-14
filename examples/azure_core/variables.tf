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

variable "username" {
  type        = string
  description = "PowerFlex manamgement platform username."
}

variable "password" {
  type        = string
  sensitive   = true
  description = "PowerFlex manamgement platform password."
}

variable "endpoint" {
  type        = string
  description = "PowerFlex manamgement platform endpoint."
}

variable "insecure" {
  type        = bool
  default     = true
  description = "Specifies if the user wants to skip SSL verification."
}

variable "login_credential" {
  type = object({
    username = string
    password = string
  })
  sensitive   = true
  description = "SSH login credential for the PowerFlex cluster nodes."
}

## We will maintain the latest version as the default version
## Use for PowerFlex 4.6 build. PowerFlex 4.5.2.1 Build 105 30 May 2024
variable "packages" {
  type = list(string)
  default = [
    "/root/PowerFlex_4.5.2100.105_SLES15.4/EMC-ScaleIO-lia-4.5-2100.105.sles15.4.x86_64.rpm",
    "/root/PowerFlex_4.5.2100.105_SLES15.4/EMC-ScaleIO-mdm-4.5-2100.105.sles15.4.x86_64.rpm",
    "/root/PowerFlex_4.5.2100.105_SLES15.4/EMC-ScaleIO-sdr-4.5-2100.105.sles15.4.x86_64.rpm",
    "/root/PowerFlex_4.5.2100.105_SLES15.4/EMC-ScaleIO-sds-4.5-2100.105.sles15.4.x86_64.rpm",
    "/root/PowerFlex_4.5.2100.105_SLES15.4/EMC-ScaleIO-sdt-4.5-2100.105.sles15.4.x86_64.rpm",
    "/root/PowerFlex_4.5.2100.105_SLES15.4/EMC-ScaleIO-activemq-5.18.3-68.noarch.rpm"
  ]
  description = "The list of path of packages."
}

variable "sds_ips" {
  type        = list(string)
  description = "PowerFlex cluster nodes IP list."
}

variable "protection_domain" {
  type        = string
  default     = "PD1"
  description = "Protection domain name."
}

variable "storage_pool" {
  type        = string
  default     = "SP1"
  description = "Storage pool name."
}

variable "data_disk_count" {
  type    = number
  validation {
    condition = (
      var.data_disk_count >= 1 &&
      var.data_disk_count <= 24
    )
    error_message = "Must be between 1 and 24."
  }
  description = "The number of data disks attached to each PowerFlex cluster node."
}

variable "is_multi_az" {
  type        = bool
  description = "Whether the PowerFlex cluster is deployed in single or multiple availability zones."
}

variable "is_balanced" {
  type        = bool
  description = "Deployment type, true for balanced type, false for optimized type."
}
