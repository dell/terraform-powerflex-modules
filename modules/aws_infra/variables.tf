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

variable "ami" {
  description = "AMI ID"
  type = map(string)
  default = {
    "installer" = "ami-installer"
    "co-res" = "ami-co-res"
  }
}


variable "application_version" {
    description = "Application Version"
    type = string
    default = "4.6"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = ["us-east-1a"]
}

variable "creator" {
  description = "Name of the cluster"
  type        = string
  default = "Dell"
}

variable "deployment_type" {
  description = "Type of deployment setup - performance or balanced"
  type        = string
  default     = "performance" # Change to "balanced" for different setup
  validation {
    condition     = var.deployment_type == "performance" || var.deployment_type == "balanced"
    error_message = "deployment_type must be either 'performance' or 'balanced'."
  }
}
locals {
   timestamp = replace(replace(replace(timestamp(), "Z", ""), ":", ""), "-", "")
}
variable "device_names" {
  type        = list(string)
  description = "the list of device names"
  default     = ["sdf", "sdg", "sdh", "sdi", "sdj", "sdk", "sdl", "sdm", "sdn", "sdo", "sdp"]
}

variable "disk_bandwidth" {
  description = "Disk bandwidth in MB/s"
  type        = number
  default     = 250
}

variable "disk_count" {
  description = "Number of disks"
  type        = number
  default     = 10
}

variable "disk_iops" {
  description = "Provisioned IOPS for the disk (only for io1 and io2)"
  type        = number
  default     = 3000
}

variable "disk_size" {
  description = "Size of the disk in GB"
  type        = number
  default     = 100
}

variable "disk_type" {
  description = "Type of the disk (gp2, gp3, io1, io2, st1, sc1)"
  type        = string
  default     = "gp2"
}

variable "generated_username" {
  type    = string
  default = "pflex-user"
}


variable "password" {
  type    = string
  default = "Password"
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 3
}

variable "instance_type" {
  description = "Type of the EC2 instance"
  type        = string
  default     = "i3en.12xlarge"
}

variable "key_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  type    = string
  default = "~/.ssh/id_rsa"
}

variable "multi_az" {
  description = "Enable multi-AZ deployment"
  type        = bool
  default     = false
}

variable "subnet_ids" {
  description = "Name of the default subnet"
  type        = list(string)
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

# variables.tf

variable "bastion_config" {
  description = "Bastion configuration"
  type = object({
    use_bastion    = bool
    bastion_host   = string
    bastion_user   = string
    bastion_ssh_key = string
  })
  default = {
    use_bastion    = false
    bastion_host   = null
    bastion_user   = "root"
    bastion_ssh_key = "~/.ssh/id_rsa.pem"
  }
}

variable "install_node_user" {
  description = "Username for the remote connection"
  type        = string
  default     = "ec2-user"
}

variable "template_file_name" {
  type    = string
  default = "user-data-pflex.tpl"
}

variable "vpn_security_group" {
  type    = string
  description = "Security group"
}

variable "private_subnet_cidr" {
  type = list(string)
  description = "the private cidr range"
}

variable "encrypted" {
  type = bool
  description = "the volume encryption flag"
  default = false
}
 