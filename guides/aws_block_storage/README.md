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

# APEX Block Deployment in AWS using Dell Terraform Module

This repository contains the Terraform Module configuration files to deploy Apex block in AWS.

## Prerequisites

Before you can use this module, you need to have the following:

- An AWS account and access to the AWS Management Console.
- Terraform installed on your local machine. You can download it from the [official Terraform website](https://www.terraform.io/downloads.html).
- AWS credentials configured on your local machine. You can use the AWS CLI to configure your credentials. You can find instructions on how to do this in the [AWS CLI documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html).
- Update the variable file with 
  A custom VPC with a subnet and security group.

To create the custom VPC, subnet, and security group, you can use the AWS Management Console or the AWS CLI.

## Optional Jump Host

If you want to use a jump host to access your EC2 instances, you can configure the module to do so. To do this, you need to provide the SSH key pair and the jump(bastion) host details. Provide ssh key details in bastion configuration in tfvars file. Linux jump host is supported. 

### Generating SSH Key Pair

To generate an SSH key pair, for ssh to powerflex nodes, you can use the following command:
`ssh-keygen -t rsa -b 4096 -f key_pair`

This will generate a private key file named 'key_pair' and public key file named key_pair.pub.

## Usage

1. Get the module to your local machine.

2. Navigate to the code examples folder

3. Create the terraform.tfvars file using sample file provided.

4. Update provider.tf with your profile and region.

5. Initialize the Terraform working directory.
 `
 terraform init
 `

6. Review the Terraform plan to see the changes that will be made.
`
terraform plan
`
7. Apply the Terraform configuration to deploy Dell Apex Block storgae.

You will be prompted to confirm the changes. Type "yes" to proceed.

8. Once the instances are created, you can verify them using the AWS Management Console or the AWS CLI.

9. You can access Apex block cluster using load balancer IP. 

## Configuration

The Terraform configuration files in this repository are organized in the following way:

- `main.tf`: The main Terraform configuration file.
- `variables.tf`: The variables file, where you can define variables to customize the configuration.
- `provider.tf`: The provider file, where you can define aws configuration.

You can modify the configuration in the `terraform.tfvars` file to customize the creation. For example, you can change the AMI ID, instance type, creator etc.
You can modify `main.tf` if you don't want to run any specific module.

## Cleaning Up

To clean up the created resources, you can use the following command:
`terraform destroy`



