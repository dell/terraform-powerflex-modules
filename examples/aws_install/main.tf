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


# main.tf

module "aws_infra" {
  # Here the source points to the a local instance of the submodule in the modules folder, if you have and instance of the modules folder locally.
  # source = "../../modules/aws_infra"

  # Here is an example of a source that pulls from the registry
  source  = "dell/modules/powerflex//modules/aws_infra"
  version = "x.x.x" // pull in the latest version like "1.2.0"

  vpc_name     = var.vpc_name
  subnet_ids = var.subnet_ids
  vpn_security_group = var.security_group
  multi_az = var.multi_az
  instance_type = var.instance_type
  instance_count = var.instance_count
  deployment_type = var.deployment_type
  key_path = var.key_path
  private_key_path = var.private_key_path
  creator                = var.creator
  application_version    = var.application_version
  bastion_config = var.bastion_config
  private_subnet_cidr = var.private_subnet_cidr
  disk_size = var.disk_size
  disk_count = var.disk_count
}

module "load-balancer" {
  source  = "dell/modules/powerflex//modules/aws_prereq/load_balancer"
  version = "x.x.x" // pull in the latest version like "1.2.0"

  application_version    = var.application_version
  creator                = var.creator
  management_ids         = module.aws_infra.management_ids
  subnet_ids             = var.subnet_ids
  vpc_id                 = var.vpc_name
  security_group         = var.security_group
  depends_on             = [module.aws_infra]
}

module "aws_install" {
  source = "dell/modules/powerflex//modules/aws_install"
  version = "x.x.x" // pull in the latest version like "1.2.0"

  installer_node_ip = module.aws_infra.installer_ip
  co_res_ips = module.aws_infra.co_res_ips
  device_mapping = module.aws_infra.device_mapping
  loadbalancer_dns = module.load-balancer.loadbalancer_dns
  loadbalancer_ip = module.load-balancer.loadbalancer_private_ip
  node_ips = module.aws_infra.management_ips
  management_ips = module.aws_infra.management_ips
  instance_type = var.instance_type
  key_path = var.key_path
  private_key_path = var.private_key_path
  multi_az = var.multi_az
  bastion_config = var.bastion_config
  interpreter = var.interpreter
  depends_on             = [module.load-balancer]
}

output "loadbalancer_dns" {
  description = "The DNS of the loadbalancer."
  value       = module.load-balancer.loadbalancer_dns
}


output "loadbalancer_private_ip" {
  description = "The IP of the loadbalancer. Apex block management webui can be accessed from this IP."
  value       = module.load-balancer.loadbalancer_private_ip
}

output "installer_ip" {
  description = "The private ip of the installer server"
  value       = module.aws_infra.installer_ip
}