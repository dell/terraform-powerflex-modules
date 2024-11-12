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


# variables.tf

variable "ami" {
  description = "Map of AMI ids for installer and co-res"
  type        = map(string)
  default =    {} 
  # example
  # default = {
  #  "installer" = "ami-123"
  #  "co-res" = "ami-456"
  #}
}

variable "creator" {
  description = "Name of the creator. This will be used in the name of resources and/or tags"
  type        = string
  default = "Dell"
} 

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "Names of the default subnet"
  type        = list(string)
}

variable "deployment_type" {
  description = "Type of deployment setup - performance or balanced"
  type        = string
  default     = "performance" # Change to "balanced" for different setup
}

variable "multi_az" {
  description = "Enable multi-AZ deployment"
  type        = bool
  default     = false
}

variable "instance_type" {
  description = "Type of the EC2 instance. Currently only i3en.12xlarge is supported for performance. i3n.metal is supported for single zone performance. c5n.9xlarge is supported for balanced."
  type        = string
  default     = "i3en.12xlarge"
}

variable "key_path" {
  description = "Path to SSH public key"
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  description = "Path to SSH private key"
  type    = string
  default = "~/.ssh/id_rsa"
}

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

variable "device_names" {
  type = list(string)
  description = "the list of device names"
  default = ["sdf","sdg","sdh","sdi","sdj","sdk","sdl","sdm","sdn","sdo","sdp"]
}

variable "application_version" {
    description = "Application Version"
    type = string
    default = "4.6"
}

variable "disk_size" {
  description = "Size of the disk in GB, size of disk can be: 500GB, 1TB, 2TB, 4TB "
  type        = number
  default     = 500
}

variable "security_group" {
  type    = string
  description = "Security group"
}

variable "private_subnet_cidr" {
  type = list(string)
  description = "the private cidr range"
}

variable "interpreter" {
  type    = list(string)
  #default = ["C:\\Program Files\\Git\\bin\\bash.exe", "-c"]
  default = ["/bin/bash", "-c"]
}

variable "instance_count" {
  description = "Number of instances to create. Currently supported count is 3 for performance and 5 for balanced deployment type. If multi_az is true, balanced should have 6 instances."
  type        = number
  default     = 3
}