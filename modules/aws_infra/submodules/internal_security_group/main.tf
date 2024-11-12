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
variable "private_subnet_cidr" {
  type = list(string)
  description = "the private cidr range"
  default = ["172.35.1.0/24"]
}
variable "creator" {
  type = string
  description = "the script aws user initiator"
}

variable "application_version" {
  type = string
  description = "the powerflex version name"
}

variable "pods_cidr" {
  type = string
  description = "the internal cluster pods cidr range"
  default = "10.42.0.0/16"
}
variable "multi_az" {
  description = "Enable multi-AZ deployment"
  type        = bool
  default     = false
}

locals {
  timestamp = replace(replace(replace(timestamp(), "Z", ""), ":", ""), "-", "")
  subnet_count = var.multi_az ? 3 : 1
}

resource "aws_security_group" "powerflex-allow-internal-traffic" {
  vpc_id = var.vpc_id
  count = local.subnet_count
  ingress {
    description = "PowerFlex - Gateway"
    from_port   = 8080
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 8080
  }
  ingress {
    description = "PowerFlex - SSO internal pod listener"
    from_port   = 8083
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 8083
  }
  ingress {
    description = "PowerFlex - SDR listener"
    from_port   = 11088
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 11088
  }
  ingress {
    description = "PowerFlex - SDS listener"
    from_port   = 7072
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 7072
  }
  ingress {
    description = "RKE2 - Canal CNI with WireGuard IPv6/dual-stack"
    from_port   = 51821
    protocol    = "udp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 51821
  }
  ingress {
    description = "PowerFlex - MDM peer connection"
    from_port   = 7611
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 7611
  }
  ingress {
    description = "PowerFlex - ActiveMQ 1"
    from_port   = 61714
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 61714
  }
  ingress {
    description = "PowerFlex - ActiveMQ 2"
    from_port   = 8161
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 8161
  }
  ingress {
    description = "PowerFlex - Thin Deployer"
    from_port   = 9433
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 9433
  }
  ingress {
    description = "PowerFlex - SDS listener"
    from_port   = 9098
    protocol    = "udp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 9098
  }
  ingress {
    description = "RKE2 - Cilium CNI health checks"
    from_port   = -1
    protocol    = "icmp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = -1
  }
  ingress {
    description = "RKE2 - NodePort port range"
    from_port   = 30000
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 32767
  }
  ingress {
    description = "Default mTLS port for MDM"
    from_port   = 8611
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 8611
  }
  ingress {
    description = "RKE2 - Calico CNI with VXLAN"
    from_port   = 4789
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 4789
  }
  ingress {
    description = "RKE2 - kubelet"
    from_port   = 10250
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 10250
  }
  ingress {
    description = "RKE2 agent nodes - Kubernetes API"
    from_port   = 9345
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 9345
  }
  ingress {
    description = "RKE2 - docker-registry"
    from_port   = 5000
    protocol    = "udp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 5000
  }
  ingress {
      description = "RKE2 - docker-registry-file-upload"
      from_port   = 9000
      protocol    = "udp"
      cidr_blocks = [var.private_subnet_cidr[count.index]]
      to_port     = 9000
  }
  ingress {
    description = "PowerFlex - Gateway"
    from_port   = 80
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 80
  }
  ingress {
    description = "NodePort access from load balancer"
    from_port   = 30400
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 30400
  }
  ingress {
    description = "RKE2 - Kubernetes API"
    from_port   = 6443
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 6443
  }
  ingress {
    description = "PowerFlex"
    from_port   = 28765
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 28765
  }
  ingress {
    description = "RKE2 - cert manager"
    from_port   = 9402
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 9402
  }
  ingress {
    description = "RKE2 - Canal CNI with WireGuard IPv4"
    from_port   = 51820
    protocol    = "udp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 51820
  }
  ingress {
    description = "RKE2 - docker-registry"
    from_port   = 5000
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 5000
  }
  ingress {
      description = "RKE2 - docker-registry-file-upload"
      from_port   = 9000
      protocol    = "tcp"
      cidr_blocks = [var.private_subnet_cidr[count.index]]
      to_port     = 9000
  }
  ingress {
    description = "PowerFlex - SDS listener"
    from_port   = 9099
    protocol    = "udp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 9099
  }
  ingress {
    description = "RKE2 - Cilium CNI VXLAN"
    from_port   = 8472
    protocol    = "udp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 8472
  }
  ingress {
    description = "PowerFlex - Gateway"
    from_port   = 8443
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 8443
  }
  ingress {
    description = "PowerFlex - AMS and MDM listener"
    from_port   = 6611
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 6611
  }
  ingress {
    description = "RKE2 - etcd peer port"
    from_port   = 2380
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 2380
  }
  ingress {
    description = "PowerFlex - HTTPs from inside"
    from_port   = 443
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 443
  }
  ingress {
    description = "PowerFlex - LIA listener"
    from_port   = 9099
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 9099
  }
  ingress {
    description = "RKE2 - Calico CNI with BGP"
    from_port   = 179
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 179
  }
  ingress {
    description = "RKE2 - Calico Typha health checks"
    from_port   = 9098
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 9098
  }
  ingress {
    description = "PowerFlex - ActiveMQ"
    from_port   = 61613
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 61613
  }
  ingress {
    description = "Allow ssh from installer"
    from_port   = 22
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 22
  }
  ingress {
    description = "RKE2 - Calico CNI with Typha"
    from_port   = 5473
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 5473
  }
  ingress {
    description = "PowerFlex - MDM Cluster member"
    from_port   = 9011
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 9011
  }
  ingress {
    description = "RKE2 - etcd client port"
    from_port   = 2379
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 2379
  }
  ingress {
    description = "RKE2 - Cilium CNI health checks"
    from_port   = 4240
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 4240
  }
  ingress {
    description = "PowerFlex - SDS listener"
    from_port   = 7072
    protocol    = "udp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 7072
  }
  ingress {
    description = "PowerFlex - Gateway core installation upload files"
    from_port   = 53
    protocol    = "udp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 53
  }
  ingress {
    description = "PowerFlex - Core SDT"
    from_port   = 4420
    protocol    = "udp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 4420
  }
  ingress {
    description = "PowerFlex - Core SDT"
    from_port   = 4420
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 4420
  }
  ingress {
    description = "PowerFlex - Core SDT"
    from_port   = 12200
    protocol    = "udp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 12200
  }
  ingress {
    description = "PowerFlex - Core SDT"
    from_port   = 12200
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 12200
  }
  ingress {
    description = "PowerFlex - Core SDT"
    from_port   = 8009
    protocol    = "udp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 8009
  }
  ingress {
    description = "PowerFlex - Core SDT"
    from_port   = 8009
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 8009
  }
  ingress {
    description = "PowerFlex - Ip-in-Ip"
    from_port   = 0
    protocol    = "94"
    cidr_blocks = [var.private_subnet_cidr[count.index]]
    to_port     = 0
  }
  ingress {
    description = "PowerFlex - pod-to-pod connectivity"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [var.pods_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "${var.application_version}-allow-internal-traffic-${count.index + 1}-${var.creator}-${local.timestamp}"
    GeneratedBy = "hashicorp terraform"
    Release     = var.application_version
    Creator     = var.creator
  }
}

output "security_group_ids" {
  description = "The ID of the private security group"
  value       = aws_security_group.powerflex-allow-internal-traffic.*.id
}