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
  source = "../../modules/aws_infra"

  vpc_name     = var.vpc_name
  subnet_ids = var.subnet_ids
  aws_region = var.aws_region
  vpn_security_group = var.vpn_security_group
  multi_az = var.multi_az
  availability_zones = var.availability_zones
  instance_type = var.instance_type
  deployment_type = var.deployment_type
  key_path = var.key_path
  private_key_path = var.private_key_path
  creator                = var.creator
  application_version    = var.application_version
  bastion_config = var.bastion_config
  install_node_user = var.remote_user
  private_subnet_cidr = var.private_subnet_cidr
}

module "load-balancer" {
  source                 = "../../modules/aws_prereq/load_balancer"
  application_version    = var.application_version
  #cluster_node_port      = var.cluster_node_port
  creator                = var.creator
  #load_balancer_port     = var.load_balancer_port
  #load_balancer_protocol = var.load_balancer_protocol
  management_ids         = module.aws_infra.management_ids
  subnet_ids             = var.subnet_ids
  #target_group_port      = var.target_group_port
  #target_group_protocol  = var.target_group_protocol
  vpc_id                 = var.vpc_name
  depends_on             = [module.aws_infra]
}

module "aws_install" {
  source = "../../modules/aws_install"

  installer_node_ip = module.aws_infra.installer_ip
  co_res_ips = module.aws_infra.co_res_ips
  device_mapping = module.aws_infra.device_mapping
  install_node_user = var.remote_user
  loadbalancer_dns = module.load-balancer.loadbalancer_dns
  loadbalancer_ip = module.load-balancer.loadbalancer_private_ip
  #password = var.password
  node_hostnames = var.node_hostnames
  node_ips = module.aws_infra.management_ips
  pfmp_hostname = var.pfmp_hostname
  management_ips = module.aws_infra.management_ips
  instance_type = var.instance_type
  key_path = var.key_path
  private_key_path = var.private_key_path
  multi_az = var.multi_az
  bastion_config = var.bastion_config
  depends_on             = [module.load-balancer]
}

