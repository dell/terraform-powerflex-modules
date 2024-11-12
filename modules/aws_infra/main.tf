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
  key_name   = "pflex_key"
  public_key = file(var.key_path)
}

resource "aws_instance" "installer_instance" {
  count         = 1
  ami           = data.aws_ami.installer_ami.id
  user_data           = data.template_file.user_data.rendered
  instance_type = "t3.xlarge" #var.instance_type
  subnet_id     = var.subnet_ids[0]
  key_name      = aws_key_pair.powerflex_key.key_name
  vpc_security_group_ids  = concat(module.internal_security_group.security_group_ids, [var.vpn_security_group])

  root_block_device {
    volume_size = var.disk_size
    volume_type = var.disk_type
    iops        = var.disk_type == "io1" || var.disk_type == "io2" ? var.disk_iops : null
  }

  tags = {
    Name        = "${var.application_version}-installer-1-${var.creator}"
    GeneratedBy = "Dell Terraform Module"
    Release     = var.application_version
    Creator     = var.creator
  }
}

output "installer_ip" {
  description = "The private ip of the installer server"
  value       = try(aws_instance.installer_instance[0].private_ip, "")
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

resource "aws_network_interface" "powerflex-co-res-network-interface" {
  count             = var.instance_count
  subnet_id         = var.subnet_ids[count.index % length(var.availability_zones)]
  security_groups   = concat(module.internal_security_group.security_group_ids, [var.vpn_security_group])
  source_dest_check = false
}


resource "aws_instance" "cores_instance" {
  count         = var.instance_count
  ami           = data.aws_ami.cores_ami.id
  user_data           = data.template_file.user_data.rendered
  instance_type = var.instance_type
  #subnet_id     = var.subnet_ids[count.index % length(var.availability_zones)]
  #availability_zone = var.multi_az ? element(var.availability_zones, count.index) : var.availability_zones[0]
  network_interface {
    network_interface_id = aws_network_interface.powerflex-co-res-network-interface[count.index].id
    device_index         = 0
  }
  key_name      = aws_key_pair.powerflex_key.key_name

  lifecycle {
    precondition  {
        condition     = var.multi_az ? length(var.availability_zones) >= 2 : true
        error_message = "When multi_az is enabled, you must specify at least two availability zones."
    }
    precondition  {
        condition     = var.deployment_type == "balanced" || var.deployment_type == "performance" ? true : false
        error_message = "Deployment type should be either balanced or performance."
    }
    precondition  {
        condition     = var.instance_count == (var.deployment_type == "performance" ? 3 : 5)
        error_message = "You must create  ${var.deployment_type == "performance" ? 3 : 5} instances."
    }
    precondition  {
        condition     =  var.multi_az && var.deployment_type == "balanced" ? var.instance_count == 6 : true
        error_message = "You must create  6 instances for multizone."
    }
  }

  dynamic "ebs_block_device" {
    for_each = var.device_names
    content {
      device_name = ebs_block_device.value
      volume_size = var.disk_size
      volume_type = var.disk_type
      iops        = var.disk_type == "io1" || var.disk_type == "io2" ? var.disk_iops : null
    }
  }


  root_block_device {
    volume_size = var.disk_size
    volume_type = var.disk_type
    iops        = var.disk_type == "io1" || var.disk_type == "io2" ? var.disk_iops : null
  }

  tags = {
    Name        = "${var.application_version}-cores-${count.index + 1}-${var.creator}"
    GeneratedBy = "Dell Terraform Module"
    Release     = var.application_version
    Creator     = var.creator
  }
}

output "management_ids" {
  description = "The ID's of the management instances"
  value       = [aws_instance.cores_instance[0].id,aws_instance.cores_instance[1].id,aws_instance.cores_instance[2].id]
}

output "management_ips" {
  description = "The ip's of the management instances"
  value       = [aws_instance.cores_instance[0].private_ip,aws_instance.cores_instance[1].private_ip,aws_instance.cores_instance[2].private_ip]
}

output "co_res_ips" {
  description = "The private ip's of the co-res servers"
  value       =  aws_instance.cores_instance.*.private_ip
}

resource "null_resource" "wait_for_instance" {
  #count = aws_instance.cores_instance.count

  depends_on = [aws_instance.cores_instance]
 
  provisioner "remote-exec" {
    
    connection {
      type        = "ssh"
      host        = aws_instance.installer_instance[0].private_ip
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
