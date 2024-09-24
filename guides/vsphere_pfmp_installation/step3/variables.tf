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

variable "ntp_ip" {
  type = string
  description = "The IP address of the NTP server."
}

variable "installer_node_ip" {
 type = string
 description = "The IP address of the PowerFlex installer node."
}

variable "node_1_ip" {
 type = string
 description = "The IP address of the PowerFlex node 1."
}

variable "node_2_ip" {
 type = string
 description = "The IP address of the PowerFlex node 2."
}

variable "node_3_ip" {
 type = string
 description = "The IP address of the PowerFlex node 3."
}

variable "username" {
  type = string
  description = "The username of the PowerFlex nodes and installer, default is 'delladmin'"
  default = "delladmin"
}

variable "use_co_res" {
  type = bool
  description = "Do a co-res deployment of PFMP, default false"
  default = false
}
