---
title: "Powerflex Management Installer EXSi"
linkTitle: "Powerflex Management Installer EXSi"
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
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.1 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vsphere_pfmp_installation"></a> [vsphere\_pfmp\_installation](#module\_vsphere\_pfmp\_installation) | ../../modules/vsphere_pfmp_installation | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_destination_path_to_set_pfmp_config"></a> [destination\_path\_to\_set\_pfmp\_config](#input\_destination\_path\_to\_set\_pfmp\_config) | The path to the PFMP\_Config is set on the installer VM, default is '/opt/dell/pfmp/PFMP\_Installer/config/PFMP\_Config.json' | `string` | `"/opt/dell/pfmp/PFMP_Installer/config/PFMP_Config.json"` | no |
| <a name="input_installer_node_ip"></a> [installer\_node\_ip](#input\_installer\_node\_ip) | The IP address of the PowerFlex installer node. | `string` | n/a | yes |
| <a name="input_local_path_to_pfmp_config"></a> [local\_path\_to\_pfmp\_config](#input\_local\_path\_to\_pfmp\_config) | The path to the PFMP\_Config on the local machine, default is './PFMP\_Config.json' | `string` | `"./PFMP_Config.json"` | no |
| <a name="input_node_1_ip"></a> [node\_1\_ip](#input\_node\_1\_ip) | The IP address of the PowerFlex node 1. | `string` | n/a | yes |
| <a name="input_node_2_ip"></a> [node\_2\_ip](#input\_node\_2\_ip) | The IP address of the PowerFlex node 2. | `string` | n/a | yes |
| <a name="input_node_3_ip"></a> [node\_3\_ip](#input\_node\_3\_ip) | The IP address of the PowerFlex node 3. | `string` | n/a | yes |
| <a name="input_ntp_ip"></a> [ntp\_ip](#input\_ntp\_ip) | The IP address of the NTP server. | `string` | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | The password of the PowerFlex nodes and installer, default is 'delladmin' | `string` | `"delladmin"` | no |
| <a name="input_username"></a> [username](#input\_username) | The username of the PowerFlex nodes and installer, default is 'delladmin' | `string` | `"delladmin"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->