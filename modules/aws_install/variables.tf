variable "installer_node_ip" {
  description = "IP address of the installer node"
  type        = string
}

variable "install_node_user" {
  description = "Username for the remote connection"
  type        = string
  default     = "ec2-user"
}

variable "key_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  type    = string
  default = "~/.ssh/id_rsa"
}

variable "co_res_ips" {
  type = list(string)
  description = "the list of co-res private ips"
}
locals {
   timestamp = replace(replace(replace(timestamp(), "Z", ""), ":", ""), "-", "")
}
variable "management_ips" {
  type = list(string)
  description = "the list of mno private ips"
}

variable "node_hostnames" {
  description = "List of node hostnames"
  type        = list(string)
  default     = ["node1", "node2", "node3"]
}
variable "generated_username" {
  type    = string
  default = "pflex-user"
}

variable "loadbalancer_dns" {
  type = string
  description = "the load balancer dns domain name"
}

variable "loadbalancer_ip" {
  type = string
  description = "the load balancer IP"
}
variable "prefix" {
  description = "Prefix to use with hostnames"
  type        = string
  default     = ""
}

variable "node_ips" {
  description = "List of node IPs"
  type        = list(string)
}

variable "mgmt_lb_range" {
  description = "Management load balancer IP range"
  type        = string
  default = "10.55.143.132-10.55.143.135"
}

variable "application_version" {
    description = "Application Version"
    type = string
    default = "4.6"
}

variable "pfmp_hostname" {
  description = "Prefix to use with hostnames"
  type        = string
  default     = "dellpowerflex.com"
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

variable "device_mapping" {
  type = list(string)
  description = "the disk device mapping"
}

variable "number_of_disks" {
  description = "Number of disks per instance"
  type    = number
  default = 1
}

variable "interpreter" {
  type    = list(string)
  #default = ["C:\\Program Files\\Git\\bin\\bash.exe", "-c"]
  default = ["/bin/bash", "-c"]
}

variable "instance_type" {
  description = "Type of the EC2 instance"
  type        = string
  #default     = "i3en.12xlarge"
  default = "t2.micro"
}

variable "multi_az" {
  description = "Enable multi-AZ deployment"
  type        = bool
  default     = false
}
