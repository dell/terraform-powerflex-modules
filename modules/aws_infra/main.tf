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

#resource "aws_vpc" "apex_vpc" {
#  cidr_block = "172.35.0.0/16"
#}

#output "vpc_id" {
#  value = aws_vpc.apex_vpc.id
#}

#resource "aws_subnet" "apex_subnet" {
#  vpc_id            = aws_vpc.apex_vpc.id
#  cidr_block        = "172.35.1.0/24"
#  availability_zone = var.aws_region
#}

data "local_file" "private_key" {
  filename   = "${var.private_key_path}"
}

data "template_file" "user_data" {
  template = file("${path.module}/${var.template_file_name}")
  vars = {
    private_key = data.local_file.private_key.content
  }
}

data "aws_ami" "installer_ami" {
  most_recent = true

  filter {
    name = "name"
    values = ["ABS Installer ${var.application_version}"]
  }

}

output "installer_ami_id" {
  value = data.aws_ami.installer_ami.id
}
module "internal_security_group" {
  source              = "./submodules/internal_security_group"
  application_version = var.application_version
  creator             = var.creator
  vpc_id              = var.vpc_name
  multi_az            = var.multi_az
  ## Update if you need to change from default values
  #pods_cidr           = var.pods_cidr
  private_subnet_cidr = var.private_subnet_cidr
}

resource "aws_key_pair" "powerflex_key" {
  key_name   = "pflex-key-var.creator"
  public_key = file(var.key_path)
}

data "aws_ami" "cores_ami" {
  most_recent = true

  filter {
    name = "name"
    values = ["ABS co-res ${var.application_version}"]
  }

}

output "cores_ami_id" {
  value = data.aws_ami.cores_ami.id
}

module "installer-server" {
  source              = "./submodules/installer_server"
  ami                 = data.aws_ami.installer_ami.id
  application_version = var.application_version
  creator             = var.creator
  instance_type       = "t3.xlarge" #lookup(var.instance_type, "installer")
  key_id              = aws_key_pair.powerflex_key.key_name
  security_group_ids  = concat(module.internal_security_group.security_group_ids, [var.vpn_security_group])
  subnet_id           = var.subnet_ids[0]
  timestamp           = local.timestamp
  user_data           = data.template_file.user_data.rendered
  depends_on          = [module.internal_security_group]
}
  
module "co-res-disk" {
  source              = "./submodules/co_res_disk"
  application_version = var.application_version
  aws_storage_az      = var.availability_zones
  creator             = var.creator
  disk_count          = var.disk_count
  disk_size           = var.disk_size
  instance_count      = var.instance_count
  timestamp           = local.timestamp
  encrypted           = var.encrypted
}

module "co-res-server" {
  source              = "./submodules/co_res_server"
  ami                 = data.aws_ami.cores_ami.id
  application_version = var.application_version
  aws_storage_az      = var.availability_zones
  creator             = var.creator
  disk_count          = var.disk_count
  instance_count      = var.instance_count
  instance_type       = var.instance_type
  key_id              = aws_key_pair.powerflex_key.key_name
  security_group_ids  = concat(module.internal_security_group.security_group_ids, [var.vpn_security_group])
  subnet_ids          = var.subnet_ids
  timestamp           = local.timestamp
  user_data           = data.template_file.user_data.rendered
  volume_ids          = module.co-res-disk.volume_ids
  encrypted           = var.encrypted
}

resource "null_resource" "wait_for_instance" {
  #count = aws_instance.cores_instance.count

  depends_on = [module.installer-server]
 
  provisioner "remote-exec" {
    
    connection {
      type        = "ssh"
      host        = module.installer-server.installer_ip

      user = var.install_node_user
      private_key = file(var.private_key_path)
      bastion_host        = var.bastion_config.use_bastion ? var.bastion_config.bastion_host : null
      bastion_user        = var.bastion_config.use_bastion ? var.bastion_config.bastion_user : null
      bastion_private_key = file(var.bastion_config.bastion_ssh_key)
    }


    inline = [
      "echo Instance is ready for SSH"
    ]
  }
}

output "management_ids" {
  description = "The ID's of the management instances"
  value       = module.co-res-server.management_ids
}

output "management_ips" {
  description = "The ip's of the management instances"
  value       = module.co-res-server.management_ips
}

output "co_res_ips" {
  description = "The private ip's of the co-res servers"
  value       =  module.co-res-server.co_res_ips
}
output "device_mapping" {
  description = "The device mapping of the disks"
  value       =  module.co-res-server.device_mapping
}

output "installer_ip" {
  description = "The private ip of the installer server"
  value       = module.installer-server.installer_ip
}