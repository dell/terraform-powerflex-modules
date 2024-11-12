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

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_copy-installation-scripts"></a> [copy-installation-scripts](#module\_copy-installation-scripts) | ./submodules/copy_installation_scripts | n/a |
| <a name="module_execute-installer-api"></a> [execute-installer-api](#module\_execute-installer-api) | ./submodules/execute_installer_api | n/a |
| <a name="module_get_hostnames"></a> [get\_hostnames](#module\_get\_hostnames) | ./submodules/get_hostnames_script | n/a |
| <a name="module_prepare-installer-api"></a> [prepare-installer-api](#module\_prepare-installer-api) | ./submodules/installer_api | n/a |
| <a name="module_remove-on-destroy"></a> [remove-on-destroy](#module\_remove-on-destroy) | ./submodules/remove_on_destroy | n/a |

## Resources

| Name | Type |
|------|------|
| [null_resource.sanitize_dir](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_version"></a> [application\_version](#input\_application\_version) | Application Version | `string` | `"4.6"` | no |
| <a name="input_bastion_config"></a> [bastion\_config](#input\_bastion\_config) | Bastion configuration | <pre>object({<br>    use_bastion    = bool<br>    bastion_host   = string<br>    bastion_user   = string<br>    bastion_ssh_key = string<br>  })</pre> | <pre>{<br>  "bastion_host": null,<br>  "bastion_ssh_key": "~/.ssh/id_rsa.pem",<br>  "bastion_user": "root",<br>  "use_bastion": false<br>}</pre> | no |
| <a name="input_co_res_ips"></a> [co\_res\_ips](#input\_co\_res\_ips) | the list of co-res private ips | `list(string)` | n/a | yes |
| <a name="input_device_mapping"></a> [device\_mapping](#input\_device\_mapping) | the disk device mapping | `list(string)` | n/a | yes |
| <a name="input_generated_username"></a> [generated\_username](#input\_generated\_username) | n/a | `string` | `"pflex-user"` | no |
| <a name="input_install_node_user"></a> [install\_node\_user](#input\_install\_node\_user) | Username for the remote connection | `string` | `"ec2-user"` | no |
| <a name="input_installer_node_ip"></a> [installer\_node\_ip](#input\_installer\_node\_ip) | IP address of the installer node | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Type of the EC2 instance | `string` | `"t2.micro"` | no |
| <a name="input_interpreter"></a> [interpreter](#input\_interpreter) | n/a | `list(string)` | <pre>[<br>  "/bin/bash",<br>  "-c"<br>]</pre> | no |
| <a name="input_key_path"></a> [key\_path](#input\_key\_path) | n/a | `string` | `"~/.ssh/id_rsa.pub"` | no |
| <a name="input_loadbalancer_dns"></a> [loadbalancer\_dns](#input\_loadbalancer\_dns) | the load balancer dns domain name | `string` | n/a | yes |
| <a name="input_loadbalancer_ip"></a> [loadbalancer\_ip](#input\_loadbalancer\_ip) | the load balancer IP | `string` | n/a | yes |
| <a name="input_management_ips"></a> [management\_ips](#input\_management\_ips) | the list of mno private ips | `list(string)` | n/a | yes |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | Enable multi-AZ deployment | `bool` | `false` | no |
| <a name="input_node_ips"></a> [node\_ips](#input\_node\_ips) | List of node IPs | `list(string)` | n/a | yes |
| <a name="input_private_key_path"></a> [private\_key\_path](#input\_private\_key\_path) | n/a | `string` | `"~/.ssh/id_rsa"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->