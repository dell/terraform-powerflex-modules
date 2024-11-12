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
  description = "the ami id of the proxy server"
}
variable "instance_type" {
  type = string
  description = "the instance type of the proxy server"
}
variable "subnet_id" {
  type = string
  description = "the relevant subnet id of the proxy server"
}
variable "security_group_ids" {
  type = list(string)
  description = "the relevant security group id of the proxy server"
}
variable "key_id" {
  type = string
  description = "the relevant access key id of the proxy server"
}
variable "user_data" {
  type = string
  description = "the user data of the instance"
  default = ""
}

resource "aws_instance" "powerflex-installer-ec2" {
  ami           = var.ami
  user_data = var.user_data
  instance_type = var.instance_type
  # VPC
  subnet_id = var.subnet_id
  # Security Group
  vpc_security_group_ids = var.security_group_ids
  # the Public SSH key
  key_name = var.key_id
  tags = {
    Name        = "${var.application_version}-installer-${var.creator}-${var.timestamp}"
    GeneratedBy = "Dell terraform PowerFlex"
    Release     = var.application_version
    Creator     = var.creator
  }
}

output "installer_ip" {
  description = "The private ip of the installer server"
  value       = try(aws_instance.powerflex-installer-ec2.private_ip, "")
}