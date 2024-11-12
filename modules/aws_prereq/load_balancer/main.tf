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



variable "vpc_id" {
  type = string
  description = "the vpc id"
}
variable "creator" {
  type = string
  description = "the script aws user initiator"
}

variable "application_version" {
  type = string
  description = "the powerflex application_version name"
}
variable "management_ids" {
  type = list(string)
  description = "the management ids array"
}

variable "cluster_node_port" {
  description = "the node port on the k8s cluster for client requests"
  type    = string
  default = "30400"
}
variable "load_balancer_port" {
  description = "the load balancer listener port"
  type    = string
  default = "443"
}
variable "load_balancer_protocol" {
  description = "the load balancer listener protocol"
  type    = string
  default = "TCP"
}
variable "target_group_port" {
  description = "the target group listener port"
  type    = string
  default = "443"
}
variable "target_group_protocol" {
  description = "the target group listener protocol"
  type    = string
  default = "TCP"
}
variable "subnet_ids" {
  type = list(string)
  description = "the load balancer subnet ids (private subnets)"
}

locals {
  timestamp = replace(replace(replace(timestamp(), "Z", ""), ":", ""), "-", "")
}

resource "aws_lb_target_group" "powerflex-network-lb-target-group" {
  name     = "${var.creator}-pflex-target-lb"
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id = var.vpc_id
  tags     = {
    GeneratedBy = "Dell Terraform Module"
    Release     = var.application_version
    TimeStamp   = local.timestamp
    Creator     = var.creator
  }
}

resource "aws_lb_target_group_attachment" "powerflex-network-lb-target-group-attachment" {
  count            = length(var.management_ids)
  target_group_arn = aws_lb_target_group.powerflex-network-lb-target-group.arn
  target_id        = var.management_ids[count.index]
  port             = var.cluster_node_port
}

resource "aws_lb" "powerflex-network-lb" {
  name                       = "${var.creator}-pflex-network-lb"
  internal                   = true
  load_balancer_type         = "network"
  enable_deletion_protection = false
  subnets                    = var.subnet_ids
  tags = {
    Name        = "${var.application_version}-nlb-${var.creator}-${local.timestamp}"
    GeneratedBy = "Dell terraform module"
    Release     = var.application_version
    TimeStamp   = local.timestamp
    Creator     = var.creator
  }
}

resource "aws_lb_listener" "powerflex-lb-listener" {
  load_balancer_arn = aws_lb.powerflex-network-lb.arn
  port              = var.load_balancer_port
  protocol          = var.load_balancer_protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.powerflex-network-lb-target-group.arn
  }
}

data "aws_network_interface" "lb_interfaces" {
  count = 1
  filter {
    name   = "description"
    values = ["ELB ${aws_lb.powerflex-network-lb.arn_suffix}"]
  }
}


output "loadbalancer_dns" {
  description = "The dns domain name of the loadbalancer"
  value       =  try(aws_lb.powerflex-network-lb.dns_name, "")
}

output "loadbalancer_private_ip" {
  description = "The dns IP of the loadbalancer"
  value = data.aws_network_interface.lb_interfaces[0].private_ip
}
