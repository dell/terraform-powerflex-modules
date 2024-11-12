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

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_lb.powerflex-network-lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.powerflex-lb-listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.powerflex-network-lb-target-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.powerflex-network-lb-target-group-attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_network_interface.lb_interfaces](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/network_interface) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_version"></a> [application\_version](#input\_application\_version) | the powerflex application\_version name | `string` | n/a | yes |
| <a name="input_cluster_node_port"></a> [cluster\_node\_port](#input\_cluster\_node\_port) | the node port on the k8s cluster for client requests | `string` | `"30400"` | no |
| <a name="input_creator"></a> [creator](#input\_creator) | the script aws user initiator | `string` | n/a | yes |
| <a name="input_load_balancer_port"></a> [load\_balancer\_port](#input\_load\_balancer\_port) | the load balancer listener port | `string` | `"443"` | no |
| <a name="input_load_balancer_protocol"></a> [load\_balancer\_protocol](#input\_load\_balancer\_protocol) | the load balancer listener protocol | `string` | `"TCP"` | no |
| <a name="input_management_ids"></a> [management\_ids](#input\_management\_ids) | the management ids array | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | the load balancer subnet ids (private subnets) | `list(string)` | n/a | yes |
| <a name="input_target_group_port"></a> [target\_group\_port](#input\_target\_group\_port) | the target group listener port | `string` | `"443"` | no |
| <a name="input_target_group_protocol"></a> [target\_group\_protocol](#input\_target\_group\_protocol) | the target group listener protocol | `string` | `"TCP"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | the vpc id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_loadbalancer_dns"></a> [loadbalancer\_dns](#output\_loadbalancer\_dns) | The dns domain name of the loadbalancer |
| <a name="output_loadbalancer_private_ip"></a> [loadbalancer\_private\_ip](#output\_loadbalancer\_private\_ip) | The dns IP of the loadbalancer |
<!-- END_TF_DOCS -->