---
title: "vSphere OVA VM Deployment"
linkTitle: "vSphere OVA VM Deployment"
description: PowerFlex Terraform module
weight: 2
---
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

## Example

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
| <a name="requirement_vsphere"></a> [vsphere](#requirement\_vsphere) | 2.8.2 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vsphere_ova_vm_deployment"></a> [vsphere\_ova\_vm\_deployment](#module\_vsphere\_ova\_vm\_deployment) | ../../modules/vsphere-ova-vm-deployment | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_unverified_ssl"></a> [allow\_unverified\_ssl](#input\_allow\_unverified\_ssl) | Allow unverified ssl connection | `string` | `true` | no |
| <a name="input_vsphere_password"></a> [vsphere\_password](#input\_vsphere\_password) | Stores the password of vsphere\_password. | `string` | n/a | yes |
| <a name="input_vsphere_server"></a> [vsphere\_server](#input\_vsphere\_server) | Stores the host ip/fqdn of the vsphere\_server. | `string` | n/a | yes |
| <a name="input_vsphere_user"></a> [vsphere\_user](#input\_vsphere\_user) | Stores the username of vsphere\_user. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->