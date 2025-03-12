<!--
Copyright (c) 2024 Dell Inc., or its subsidiaries. All Rights Reserved.

Licensed under the Mozilla Public License Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://mozilla.org/MPL/2.0/


Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->
main.tf

```hcl

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.90.0"
    }
  }
}

provider "aws" {
  region = "" // Input your region i.e "us-east-1"
  // For more information on the different aws provider configurations check out here: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
  profile = "" // Input your aws provider i.e "default"
}

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
```

terraform.tfvars
```hcl
#Sample tfvars file

#Name of the creator. This will be used in the name of resources and/or tags
creator = "MyName-MyCompany-TF"
#Type of deployment setup - performance or balanced
deployment_type = "performance"
#Size of the disk in GB, size of disk can be: 500GB, 1TB, 2TB, 4TB
disk_size = 512
#number of disks per instance. Set 10 for balanced and 0 for performance
disk_count = 10
#Number of instances. Number of instances to create. Currently supported count is 3 for performance and 5 for balanced deployment type. If multi_az is true, balanced should have 6 instances.
instance_count = 3

#Type of the EC2 instance. Currently only i3en.12xlarge is supported for performance in multi zone. i3n.metal is supported for single zone performance. c5n.9xlarge is supported for balanced.
instance_type = "i3en.12xlarge"
#application version
application_version="4.6"

#Name of the vpc (see the guide for more details)
vpc_name= "vpc-12345678901234567"
#subnet ids (see the guide for more details)
subnet_ids = ["subnet-12345678901234567"]
#Path to SSH public key
key_path = "/root/.ssh/id_rsa.pub"
#Path to SSH private key
private_key_path = "/root/.ssh/id_rsa"

#Bastion (jump host) configuration (see the guide for more details)
bastion_config = {
    use_bastion    = true
    bastion_host   = "1.2.3.7"
    bastion_user   = "root"
    bastion_ssh_key = "/root/.ssh/jump-server.pem"
}
# security group (see the guide for more details)
security_group = "sg-12345678901234567"

#the private cidr range (see the guide for more details)
private_subnet_cidr = ["172.1.0.0/24"]

#the interpreter used for shell script (see the variables.tf for other example)
interpreter = ["/bin/bash", "-c"]

# Map of AMI ids for installer and co-res (optional). If not provided, it will try to find based on the application_version provided.
ami = {
    "installer" = "ami-123"
    "co-res" = "ami-456"
  }
  
#Enable multi availability zone deployment (boolean)
multi_az = false
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_copy-installation-scripts"></a> [copy-installation-scripts](#module\_copy-installation-scripts) | ./submodules/copy_installation_scripts | n/a |
| <a name="module_execute-installer-api"></a> [execute-installer-api](#module\_execute-installer-api) | ./submodules/execute_installer_api | n/a |
| <a name="module_get_hostnames"></a> [get\_hostnames](#module\_get\_hostnames) | ./submodules/get_hostnames_script | n/a |
| <a name="module_prepare-installer-api"></a> [prepare-installer-api](#module\_prepare-installer-api) | ./submodules/installer_api | n/a |
| <a name="module_remove-on-destroy"></a> [remove-on-destroy](#module\_remove-on-destroy) | ./submodules/remove_on_destroy | n/a |

## Resources

| Name | Type |
|------|------|
| [null_resource.sanitize_dir](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_version"></a> [application\_version](#input\_application\_version) | Application Version | `string` | `"4.6"` | no |
| <a name="input_bastion_config"></a> [bastion\_config](#input\_bastion\_config) | Bastion configuration | <pre>object({<br>    use_bastion    = bool<br>    bastion_host   = string<br>    bastion_user   = string<br>    bastion_ssh_key = string<br>  })</pre> | <pre>{<br>  "bastion_host": null,<br>  "bastion_ssh_key": "~/.ssh/id_rsa.pem",<br>  "bastion_user": "root",<br>  "use_bastion": false<br>}</pre> | no |
| <a name="input_co_res_ips"></a> [co\_res\_ips](#input\_co\_res\_ips) | the list of co-res private ips | `list(string)` | n/a | yes |
| <a name="input_device_mapping"></a> [device\_mapping](#input\_device\_mapping) | the disk device mapping | `list(string)` | n/a | yes |
| <a name="input_generated_username"></a> [generated\_username](#input\_generated\_username) | n/a | `string` | `"pflex-user"` | no |
| <a name="input_install_node_user"></a> [install\_node\_user](#input\_install\_node\_user) | Username for the remote connection | `string` | `"ec2-user"` | no |
| <a name="input_installer_node_ip"></a> [installer\_node\_ip](#input\_installer\_node\_ip) | IP address of the installer node | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Type of the EC2 instance | `string` | `"t2.micro"` | no |
| <a name="input_interpreter"></a> [interpreter](#input\_interpreter) | n/a | `list(string)` | <pre>[<br>  "/bin/bash",<br>  "-c"<br>]</pre> | no |
| <a name="input_key_path"></a> [key\_path](#input\_key\_path) | n/a | `string` | `"~/.ssh/id_rsa.pub"` | no |
| <a name="input_loadbalancer_dns"></a> [loadbalancer\_dns](#input\_loadbalancer\_dns) | the load balancer dns domain name | `string` | n/a | yes |
| <a name="input_loadbalancer_ip"></a> [loadbalancer\_ip](#input\_loadbalancer\_ip) | the load balancer IP | `string` | n/a | yes |
| <a name="input_management_ips"></a> [management\_ips](#input\_management\_ips) | the list of mno private ips | `list(string)` | n/a | yes |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | Enable multi-AZ deployment | `bool` | `false` | no |
| <a name="input_node_ips"></a> [node\_ips](#input\_node\_ips) | List of node IPs | `list(string)` | n/a | yes |
| <a name="input_private_key_path"></a> [private\_key\_path](#input\_private\_key\_path) | n/a | `string` | `"~/.ssh/id_rsa"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->