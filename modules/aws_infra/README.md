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
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_co-res-disk"></a> [co-res-disk](#module\_co-res-disk) | ./submodules/co_res_disk | n/a |
| <a name="module_co-res-server"></a> [co-res-server](#module\_co-res-server) | ./submodules/co_res_server | n/a |
| <a name="module_installer-server"></a> [installer-server](#module\_installer-server) | ./submodules/installer_server | n/a |
| <a name="module_internal_security_group"></a> [internal\_security\_group](#module\_internal\_security\_group) | ./submodules/internal_security_group | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_key_pair.powerflex_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [null_resource.wait_for_instance](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_ami.cores_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.installer_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [local_file.private_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |
| [template_file.user_data](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami"></a> [ami](#input\_ami) | AMI ID | `map(string)` | <pre>{<br>  "co-res": "ami-co-res",<br>  "installer": "ami-installer"<br>}</pre> | no |
| <a name="input_application_version"></a> [application\_version](#input\_application\_version) | Application Version | `string` | `"4.6"` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones to use | `list(string)` | <pre>[<br>  "us-east-1a"<br>]</pre> | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_bastion_config"></a> [bastion\_config](#input\_bastion\_config) | Bastion configuration | <pre>object({<br>    use_bastion    = bool<br>    bastion_host   = string<br>    bastion_user   = string<br>    bastion_ssh_key = string<br>  })</pre> | <pre>{<br>  "bastion_host": null,<br>  "bastion_ssh_key": "~/.ssh/id_rsa.pem",<br>  "bastion_user": "root",<br>  "use_bastion": false<br>}</pre> | no |
| <a name="input_creator"></a> [creator](#input\_creator) | Name of the cluster | `string` | `"Dell"` | no |
| <a name="input_deployment_type"></a> [deployment\_type](#input\_deployment\_type) | Type of deployment setup - performance or balanced | `string` | `"performance"` | no |
| <a name="input_device_names"></a> [device\_names](#input\_device\_names) | the list of device names | `list(string)` | <pre>[<br>  "sdf",<br>  "sdg",<br>  "sdh",<br>  "sdi",<br>  "sdj",<br>  "sdk",<br>  "sdl",<br>  "sdm",<br>  "sdn",<br>  "sdo",<br>  "sdp"<br>]</pre> | no |
| <a name="input_disk_bandwidth"></a> [disk\_bandwidth](#input\_disk\_bandwidth) | Disk bandwidth in MB/s | `number` | `250` | no |
| <a name="input_disk_count"></a> [disk\_count](#input\_disk\_count) | Number of disks | `number` | `10` | no |
| <a name="input_disk_iops"></a> [disk\_iops](#input\_disk\_iops) | Provisioned IOPS for the disk (only for io1 and io2) | `number` | `3000` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | Size of the disk in GB | `number` | `100` | no |
| <a name="input_disk_type"></a> [disk\_type](#input\_disk\_type) | Type of the disk (gp2, gp3, io1, io2, st1, sc1) | `string` | `"gp2"` | no |
| <a name="input_encrypted"></a> [encrypted](#input\_encrypted) | the volume encryption flag | `bool` | `false` | no |
| <a name="input_generated_username"></a> [generated\_username](#input\_generated\_username) | n/a | `string` | `"pflex-user"` | no |
| <a name="input_install_node_user"></a> [install\_node\_user](#input\_install\_node\_user) | Username for the remote connection | `string` | `"ec2-user"` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of instances to create | `number` | `3` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Type of the EC2 instance | `string` | `"i3en.12xlarge"` | no |
| <a name="input_key_path"></a> [key\_path](#input\_key\_path) | n/a | `string` | `"~/.ssh/id_rsa.pub"` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | Enable multi-AZ deployment | `bool` | `false` | no |
| <a name="input_password"></a> [password](#input\_password) | n/a | `string` | `"Password"` | no |
| <a name="input_private_key_path"></a> [private\_key\_path](#input\_private\_key\_path) | n/a | `string` | `"~/.ssh/id_rsa"` | no |
| <a name="input_private_subnet_cidr"></a> [private\_subnet\_cidr](#input\_private\_subnet\_cidr) | the private cidr range | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Name of the default subnet | `list(string)` | n/a | yes |
| <a name="input_template_file_name"></a> [template\_file\_name](#input\_template\_file\_name) | n/a | `string` | `"user-data-pflex.tpl"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC | `string` | n/a | yes |
| <a name="input_vpn_security_group"></a> [vpn\_security\_group](#input\_vpn\_security\_group) | Security group | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_co_res_ips"></a> [co\_res\_ips](#output\_co\_res\_ips) | The private ip's of the co-res servers |
| <a name="output_cores_ami_id"></a> [cores\_ami\_id](#output\_cores\_ami\_id) | n/a |
| <a name="output_device_mapping"></a> [device\_mapping](#output\_device\_mapping) | The device mapping of the disks |
| <a name="output_installer_ami_id"></a> [installer\_ami\_id](#output\_installer\_ami\_id) | n/a |
| <a name="output_installer_ip"></a> [installer\_ip](#output\_installer\_ip) | The private ip of the installer server |
| <a name="output_management_ids"></a> [management\_ids](#output\_management\_ids) | The ID's of the management instances |
| <a name="output_management_ips"></a> [management\_ips](#output\_management\_ips) | The ip's of the management instances |
<!-- END_TF_DOCS -->