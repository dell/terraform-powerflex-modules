---
title: "Apex Block for AWS module"
linkTitle: "Apex Block for AWS module"
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

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_infra"></a> [aws\_infra](#module\_aws\_infra) | ../../modules/aws_infra | n/a |
| <a name="module_aws_install"></a> [aws\_install](#module\_aws\_install) | ../../modules/aws_install | n/a |
| <a name="module_load-balancer"></a> [load-balancer](#module\_load-balancer) | ../../modules/aws_prereq/load_balancer | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami"></a> [ami](#input\_ami) | Map of AMI ids for installer and co-res | `map(string)` | <pre>{<br>  "co-res": "ami-085e25c4320e48e22",<br>  "installer": "ami-082522aee30d88d15"<br>}</pre> | no |
| <a name="input_application_version"></a> [application\_version](#input\_application\_version) | Application Version | `string` | `"4.6"` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones to use | `list(string)` | <pre>[<br>  "us-east-1a"<br>]</pre> | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_bastion_config"></a> [bastion\_config](#input\_bastion\_config) | Bastion configuration | <pre>object({<br>    use_bastion    = bool<br>    bastion_host   = string<br>    bastion_user   = string<br>    bastion_ssh_key = string<br>  })</pre> | <pre>{<br>  "bastion_host": null,<br>  "bastion_ssh_key": "~/.ssh/id_rsa.pem",<br>  "bastion_user": "root",<br>  "use_bastion": false<br>}</pre> | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster | `string` | n/a | yes |
| <a name="input_creator"></a> [creator](#input\_creator) | Name of the cluster | `string` | `"Dell"` | no |
| <a name="input_deployment_type"></a> [deployment\_type](#input\_deployment\_type) | Type of deployment setup - performance or balanced | `string` | `"performance"` | no |
| <a name="input_device_names"></a> [device\_names](#input\_device\_names) | the list of device names | `list(string)` | <pre>[<br>  "sdf",<br>  "sdg",<br>  "sdh",<br>  "sdi",<br>  "sdj",<br>  "sdk",<br>  "sdl",<br>  "sdm",<br>  "sdn",<br>  "sdo",<br>  "sdp"<br>]</pre> | no |
| <a name="input_disk_bandwidth"></a> [disk\_bandwidth](#input\_disk\_bandwidth) | Disk bandwidth in MB/s | `number` | `250` | no |
| <a name="input_disk_count"></a> [disk\_count](#input\_disk\_count) | Number of disks | `number` | `10` | no |
| <a name="input_disk_iops"></a> [disk\_iops](#input\_disk\_iops) | Provisioned IOPS for the disk (only for io1 and io2) | `number` | `3000` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | Size of the disk in GB | `number` | `100` | no |
| <a name="input_disk_type"></a> [disk\_type](#input\_disk\_type) | Type of the disk (gp2, gp3, io1, io2, st1, sc1) | `string` | `"gp2"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Type of the EC2 instance | `string` | `"i3en.12xlarge"` | no |
| <a name="input_key_path"></a> [key\_path](#input\_key\_path) | n/a | `string` | `"~/.ssh/id_rsa.pub"` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | Enable multi-AZ deployment | `bool` | `false` | no |
| <a name="input_node_hostnames"></a> [node\_hostnames](#input\_node\_hostnames) | List of node hostnames | `list(string)` | <pre>[<br>  "node1",<br>  "node2",<br>  "node3"<br>]</pre> | no |
| <a name="input_password"></a> [password](#input\_password) | Password for the Cluster nodes | `string` | `"Password123!"` | no |
| <a name="input_pfmp_hostname"></a> [pfmp\_hostname](#input\_pfmp\_hostname) | Prefix to use with hostnames | `string` | `"dellpowerflex.com"` | no |
| <a name="input_private_key_path"></a> [private\_key\_path](#input\_private\_key\_path) | n/a | `string` | `"~/.ssh/id_rsa"` | no |
| <a name="input_private_subnet_cidr"></a> [private\_subnet\_cidr](#input\_private\_subnet\_cidr) | the private cidr range | `list(string)` | n/a | yes |
| <a name="input_remote_user"></a> [remote\_user](#input\_remote\_user) | Username for the remote connection | `string` | `"ec2-user"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Names of the default subnet | `list(string)` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC | `string` | n/a | yes |
| <a name="input_vpn_security_group"></a> [vpn\_security\_group](#input\_vpn\_security\_group) | Security group | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->