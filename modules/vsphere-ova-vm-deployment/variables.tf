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

variable "use_remote_path" {
    type = bool
    description = "Whether or not to use a remote location or a local path, default to `true`"
    default = true
}

variable "vm_name" {
    type = string
    description = "Name of the PFMP installer VM, default to `new_terraform_vm`"
    default = "new_terraform_vm"
}

variable "vm_ova_path" {
    type = string
    description = "Path of the powerflex manager VM OVA, if local `/example/test/example_vm.ova` if remote `https://<ip>/example/example_vm.ova`"
}

variable "vsphere_datacenter_name" {
  type = string
  description = "The name of the datacenter in which to deploy the virtual machines."
}

variable "vsphere_datastore_name" {
  type = string
  description = "The name of the vSphere datastore in which to deploy the virtual machines."
}

variable "vsphere_network_name" {
  type = string
  description = "The name of the vSphere datastore in which to deploy the virtual machines."
}

variable "vsphere_resource_pool_name" {
  type = string
  description = "The name of the vSphere resource pool in which to deploy the virtual machines."
}

variable "vsphere_host_name" {
  type = string
  description = "The name of the vSphere host in which to deploy the virtual machines."
}

variable "disk_provisioning" {
  type = string
  description = "The disk provisioning type for the virtual machine. Options (thin, flat, think, sameAsSource) defaults to `thin`"
  default = "thin"
}

variable "ip_protocol" {
  type = string
  description = "The IP protocol for the virtual machine. Defaults to `IPV4`"
  default = "IPV4"
}

variable "ip_allocation_policy" {
  type = string
  description = "The IP allocation policy for the virtual machine. Defaults to `STATIC_MANUAL`"
  default = "STATIC_MANUAL"
}

variable "allow_unverified_ssl" {
  type = string
  description = "Allow unverified ssl connection"
  default = true
}