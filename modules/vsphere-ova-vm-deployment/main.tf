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

data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter_name
}

data "vsphere_datastore" "datastore" {
  name = var.vsphere_datastore_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "pool" {
  name = var.vsphere_resource_pool_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "host" {
  name = var.vsphere_host_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name = var.vsphere_network_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

## Trying to deploy vm using remote ova
resource "vsphere_virtual_machine" "vm-installer-remote" {
  count = var.use_remote_path ? 1 : 0
  name = var.vm_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
  datastore_id         = data.vsphere_datastore.datastore.id
  host_system_id       = data.vsphere_host.host.id
  resource_pool_id = data.vsphere_resource_pool.pool.id

  num_cpus = var.num_cpus
  memory = var.memory
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0

  network_interface {
    network_id = data.vsphere_network.network.id
    adapter_type = var.adapter_type 
  }

  ovf_deploy {
    allow_unverified_ssl_cert = var.allow_unverified_ssl
    remote_ovf_url = var.vm_ova_path
    disk_provisioning = var.disk_provisioning
    ip_protocol = var.ip_protocol
    ip_allocation_policy = var.ip_allocation_policy

    ovf_network_map = {
      network_id = data.vsphere_network.network.id
    }
  }
}

## Trying to deploy vm using local ova
resource "vsphere_virtual_machine" "vm-installer-local" {
  count = var.use_remote_path ? 0 : 1
  name = var.vm_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
  datastore_id         = data.vsphere_datastore.datastore.id
  host_system_id       = data.vsphere_host.host.id
  resource_pool_id = data.vsphere_resource_pool.pool.id

  num_cpus = var.num_cpus
  memory = var.memory
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0

  network_interface {
    network_id = data.vsphere_network.network.id
    adapter_type = var.adapter_type 
  }

  ovf_deploy {
    allow_unverified_ssl_cert = var.allow_unverified_ssl
    local_ovf_path = var.vm_ova_path
    disk_provisioning = var.disk_provisioning
    ip_protocol = var.ip_protocol
    ip_allocation_policy = var.ip_allocation_policy

    ovf_network_map = {
      "VM Network" = data.vsphere_network.network.id
    }
  }
}
