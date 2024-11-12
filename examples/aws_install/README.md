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
## Example inputs

terraform.tfvars
```hcl
creator = "Me-MyCompany-TF"
deployment_type = "performance"
disk_size = 500
instance_count = 3
instance_type = "i3en.12xlarge"
application_version="4.6"

load_balancer_name = "my-load-balancer"
vpc_name= "vpc-023451345"
subnet_ids = ["subnet-993d4d63"]
key_path = "/root/.ssh/id_rsa.pub" # provide full path
private_key_path = "/root/.ssh/id_rsa" # provide full path
bastion_config = {
    use_bastion    = true
    bastion_host   = "1.2.3.7"
    bastion_user   = "root"
    bastion_ssh_key = "/root/.ssh/jump-server.pem"
}
security_group = "sg-123456789"
private_subnet_cidr = ["172.0.0.0/24"]
```

Refer guides and individual module's README.md file for more information and variables.
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
| <a name="input_ami"></a> [ami](#input\_ami) | Map of AMI ids for installer and co-res | `map(string)` | `{}` | no |
| <a name="input_application_version"></a> [application\_version](#input\_application\_version) | Application Version | `string` | `"4.6"` | no |
| <a name="input_bastion_config"></a> [bastion\_config](#input\_bastion\_config) | Bastion configuration | <pre>object({<br>    use_bastion    = bool<br>    bastion_host   = string<br>    bastion_user   = string<br>    bastion_ssh_key = string<br>  })</pre> | <pre>{<br>  "bastion_host": null,<br>  "bastion_ssh_key": "~/.ssh/id_rsa.pem",<br>  "bastion_user": "root",<br>  "use_bastion": false<br>}</pre> | no |
| <a name="input_creator"></a> [creator](#input\_creator) | Name of the creator. This will be used in the name of resources and/or tags | `string` | `"Dell"` | no |
| <a name="input_deployment_type"></a> [deployment\_type](#input\_deployment\_type) | Type of deployment setup - performance or balanced | `string` | `"performance"` | no |
| <a name="input_device_names"></a> [device\_names](#input\_device\_names) | the list of device names | `list(string)` | <pre>[<br>  "sdf",<br>  "sdg",<br>  "sdh",<br>  "sdi",<br>  "sdj",<br>  "sdk",<br>  "sdl",<br>  "sdm",<br>  "sdn",<br>  "sdo",<br>  "sdp"<br>]</pre> | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | Size of the disk in GB, size of disk can be: 500GB, 1TB, 2TB, 4TB | `number` | `500` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of instances to create. Currently supported count is 3 for performance and 5 for balanced deployment type. If multi\_az is true, balanced should have 6 instances. | `number` | `3` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Type of the EC2 instance. Currently only i3en.12xlarge is supported for performance. i3n.metal is supported for single zone performance. c5n.9xlarge is supported for balanced. | `string` | `"i3en.12xlarge"` | no |
| <a name="input_interpreter"></a> [interpreter](#input\_interpreter) | n/a | `list(string)` | <pre>[<br>  "/bin/bash",<br>  "-c"<br>]</pre> | no |
| <a name="input_key_path"></a> [key\_path](#input\_key\_path) | Path to SSH public key | `string` | `"~/.ssh/id_rsa.pub"` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | Enable multi-AZ deployment | `bool` | `false` | no |
| <a name="input_private_key_path"></a> [private\_key\_path](#input\_private\_key\_path) | Path to SSH private key | `string` | `"~/.ssh/id_rsa"` | no |
| <a name="input_private_subnet_cidr"></a> [private\_subnet\_cidr](#input\_private\_subnet\_cidr) | the private cidr range | `list(string)` | n/a | yes |
| <a name="input_security_group"></a> [security\_group](#input\_security\_group) | Security group | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Names of the default subnet | `list(string)` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_loadbalancer_dns"></a> [loadbalancer\_dns](#output\_loadbalancer\_dns) | The DNS of the loadbalancer. |
| <a name="output_loadbalancer_private_ip"></a> [loadbalancer\_private\_ip](#output\_loadbalancer\_private\_ip) | The IP of the loadbalancer. Apex block management webui can be accessed from this IP. |
<!-- END_TF_DOCS -->