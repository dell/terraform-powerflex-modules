variable "creator" {
  type = string
  description = "the script aws user initiator"
}
variable "timestamp" {
  type = string
  description = "the current timestamp"
}
variable "application_version" {
  type = string
  description = "the powerflex version name"
}
variable "ami" {
  type = string
  description = "the ami id of the co-res server"
}
variable "instance_type" {
  type = string
  description = "the instance type of the co-res server"
}
variable "subnet_ids" {
  type = list(string)
  description = "the relevant subnet id of the co-res server"
}
variable "security_group_ids" {
  type = list(string)
  description = "the relevant security group id of the co-res server"
}
variable "volume_ids" {
  type = list(string)
  description = "the list of volume ids"
}
variable "device_names" {
  type = list(string)
  description = "the list of device names"
  default = ["sdf","sdg","sdh","sdi","sdj","sdk","sdl","sdm","sdn","sdo","sdp"]
}
variable "key_id" {
  type = string
  description = "the relevant access key id of the co-res server"
}
variable "instance_count" {
  type = number
  description = "the number of co-res instances"
}
variable "disk_count" {
  type = number
  description = "the number of disks per instance"
}
variable "aws_storage_az" {
  type = list(string)
  description = "the different availability zones list"
}
variable "user_data" {
  type = string
  description = "the user data of the instance"
  default = ""
}
variable "encrypted" {
  type = bool
  description = "the encryption status of the root volume"
  default = false
}
variable "deployment_type" {
  description = "Type of deployment setup - performance or balanced"
  type        = string
}

variable "multi_az" {
  description = "Enable multi-AZ deployment"
  type        = bool
}


resource "aws_network_interface" "powerflex-co-res-network-interface" {
  count             = var.instance_count
  subnet_id         = var.subnet_ids[count.index % length(var.aws_storage_az)]
  security_groups   = var.security_group_ids
  source_dest_check = false
}

resource "aws_instance" "powerflex-co-res-ec2" {
  count         = var.instance_count
  ami           = var.ami
  instance_type = var.instance_type
  network_interface {
    network_interface_id = aws_network_interface.powerflex-co-res-network-interface[count.index].id
    device_index         = 0
  }
  root_block_device {
    volume_size = count.index < 3 ? 600 : 32 # 600GB for PFMP node and 32GB for regular co-res nodes
    encrypted = var.encrypted
  }
  user_data = var.user_data
  # the Public SSH key
  key_name = var.key_id

  lifecycle {
    precondition  {
        condition     = var.multi_az ? length(var.aws_storage_az) >= 2 : true
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

  tags = {
    Name        = "${var.application_version}-co-res-${count.index + 1}-${var.creator}-${var.timestamp}"
    GeneratedBy = "Dell terraform PowerFlex"
    Release     = var.application_version
    Creator     = var.creator
  }
}

resource "aws_volume_attachment" "assign-disk-to-powerflex-mdm" {
  count       = var.instance_count * var.disk_count
  device_name = "/dev/${var.device_names[count.index % var.disk_count]}"
  volume_id   = var.volume_ids[count.index]
  instance_id = aws_instance.powerflex-co-res-ec2[floor(count.index/var.disk_count)].id
}

output "management_ids" {
  description = "The ID's of the management instances"
  value       = [aws_instance.powerflex-co-res-ec2[0].id,aws_instance.powerflex-co-res-ec2[1].id,aws_instance.powerflex-co-res-ec2[2].id]
}

output "management_ips" {
  description = "The ip's of the management instances"
  value       = [aws_instance.powerflex-co-res-ec2[0].private_ip,aws_instance.powerflex-co-res-ec2[1].private_ip,aws_instance.powerflex-co-res-ec2[2].private_ip]
}

output "co_res_ips" {
  description = "The private ip's of the co-res servers"
  value       =  aws_instance.powerflex-co-res-ec2.*.private_ip
}
output "device_mapping" {
  description = "The device mapping of the disks"
  value       =  aws_volume_attachment.assign-disk-to-powerflex-mdm.*.device_name
}



