<!--
Copyright (c) 2024 Dell Inc., or its subsidiaries. All Rights Reserved.

Licensed under the Mozilla Public License Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://mozilla.org/MPL/2.0/


Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->

main.tf
```hcl
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
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_vsphere"></a> [vsphere](#requirement\_vsphere) | >= 2.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vsphere"></a> [vsphere](#provider\_vsphere) | >= 2.7.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [vsphere_virtual_machine.vm-installer-local](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/resources/virtual_machine) | resource |
| [vsphere_virtual_machine.vm-installer-remote](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/resources/virtual_machine) | resource |
| [vsphere_datacenter.datacenter](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/datacenter) | data source |
| [vsphere_datastore.datastore](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/datastore) | data source |
| [vsphere_host.host](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/host) | data source |
| [vsphere_network.network](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/network) | data source |
| [vsphere_resource_pool.pool](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/resource_pool) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_adapter_type"></a> [adapter\_type](#input\_adapter\_type) | Network Adapter Type for the virtual machine. Defaults to `vmxnet3` Options can be found here: https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.vm_admin.doc/GUID-AF9E24A8-2CFA-447B-AC83-35D563119667.html | `string` | `"vmxnet3"` | no |
| <a name="input_allow_unverified_ssl"></a> [allow\_unverified\_ssl](#input\_allow\_unverified\_ssl) | Allow unverified ssl connection | `string` | `true` | no |
| <a name="input_disk_provisioning"></a> [disk\_provisioning](#input\_disk\_provisioning) | The disk provisioning type for the virtual machine. Options (thin, flat, think, sameAsSource) defaults to `thin` | `string` | `"thin"` | no |
| <a name="input_ip_allocation_policy"></a> [ip\_allocation\_policy](#input\_ip\_allocation\_policy) | The IP allocation policy for the virtual machine. Defaults to `STATIC_MANUAL` | `string` | `"STATIC_MANUAL"` | no |
| <a name="input_ip_protocol"></a> [ip\_protocol](#input\_ip\_protocol) | The IP protocol for the virtual machine. Defaults to `IPV4` | `string` | `"IPV4"` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | Memory for the virtual machine. Defaults to `4060` | `number` | `4060` | no |
| <a name="input_num_cpus"></a> [num\_cpus](#input\_num\_cpus) | Number of CPUs for the virtual machine. Defaults to `1` | `number` | `1` | no |
| <a name="input_use_remote_path"></a> [use\_remote\_path](#input\_use\_remote\_path) | Whether or not to use a remote location or a local path, default to `true` | `bool` | `true` | no |
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | Name of the PFMP installer VM, default to `new_terraform_vm` | `string` | `"new_terraform_vm"` | no |
| <a name="input_vm_ova_path"></a> [vm\_ova\_path](#input\_vm\_ova\_path) | Path of the powerflex manager VM OVA, if local `/example/test/example_vm.ova` if remote `https://<ip>/example/example_vm.ova` | `string` | n/a | yes |
| <a name="input_vsphere_datacenter_name"></a> [vsphere\_datacenter\_name](#input\_vsphere\_datacenter\_name) | The name of the datacenter in which to deploy the virtual machines. | `string` | n/a | yes |
| <a name="input_vsphere_datastore_name"></a> [vsphere\_datastore\_name](#input\_vsphere\_datastore\_name) | The name of the vSphere datastore in which to deploy the virtual machines. | `string` | n/a | yes |
| <a name="input_vsphere_host_name"></a> [vsphere\_host\_name](#input\_vsphere\_host\_name) | The name of the vSphere host in which to deploy the virtual machines. | `string` | n/a | yes |
| <a name="input_vsphere_network_name"></a> [vsphere\_network\_name](#input\_vsphere\_network\_name) | The name of the vSphere datastore in which to deploy the virtual machines. | `string` | n/a | yes |
| <a name="input_vsphere_resource_pool_name"></a> [vsphere\_resource\_pool\_name](#input\_vsphere\_resource\_pool\_name) | The name of the vSphere resource pool in which to deploy the virtual machines. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vsphere_virtual_machine_local"></a> [vsphere\_virtual\_machine\_local](#output\_vsphere\_virtual\_machine\_local) | n/a |
| <a name="output_vsphere_virtual_machine_remote"></a> [vsphere\_virtual\_machine\_remote](#output\_vsphere\_virtual\_machine\_remote) | n/a |
<!-- END_TF_DOCS -->