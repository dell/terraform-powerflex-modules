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

#####################################
# Deploy vSphere OVA Virtual Machine
#####################################

module "vsphere_ova_vm_deployment" {
  # Here the source points to the a local instance of the submodule in the modules folder, if you have and instance of the modules folder locally.
  # source = "../../modules/vsphere-ova-vm-deployment"

  # Here is an example of a source that pulls from the registry
  source  = "dell/modules/powerflex//modules/vsphere_pfmp_installation"
  version = "x.x.x" // pull in the latest version like "1.2.0"

  # Required
  vm_ova_path = "https://example.com/path/to/example.ova"
  vsphere_datacenter_name = "datacenter"
  vsphere_datastore_name = "datastore"
  vsphere_network_name = "network"
  vsphere_host_name = "host-name"
  vsphere_resource_pool_name = "resource-pool"


  # Optional values which if not set have default values
  # vm_name = "example-name"
  # use_remote_path = false
  # allow_unverified_ssl = false
  # num_cpus = 8
  # memory = 8120
  # adapter_type = "vmxnet3"
}
