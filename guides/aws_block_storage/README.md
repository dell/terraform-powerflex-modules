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

- A custom VPC (Enabled DNS settings) along with a subnet and security group that allows all traffic from a specific CIDR block.
- Before using this module, please make sure you have `dos2unix` installed on your local machine.

## Optional Jump Host

To securely manage instances in private subnets, a bastion host (jump host) is required. You don't need to configure bastion host if you can have access to your EC2 instances through VPN or directly. If you are going to use, ensure that the bastion host is configured within the subnet and has access to the private subnet via SSH. Additionally, the subnet CIDR must allow inbound SSH (port 22) and HTTPS (port 443) traffic to facilitate secure connections and management.

If you want to use a jump host to access your EC2 instances, you can configure this module to do so. To configure, you need to provide the SSH key pair and the jump(bastion) host details. Provide ssh key details in bastion configuration in tfvars file. Linux jump host is supported.

### Generating SSH Key Pair

To generate an SSH key pair, for ssh to powerflex nodes, you can use the following command:
```
ssh-keygen -t rsa -b 4096 -f key_pair`
```
This will generate a private key file named 'key_pair' and public key file named key_pair.pub.
Next, Define permissions for key. From the linux bastion execute:
```
chmod 600 id_rsa
chmod 600 id_rsa.pub
```

## Support Matrix

This module supports the following operating systems:

- Linux (for both the local machine and the bastion host, if used)
- Windows with VSCode - GitBash

  - [Install the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
  - [Configure AWS credentials and profile](https://docs.aws.amazon.com/cli/v1/userguide/cli-chap-configure.html#configure-precedence)
  - Update ../aws_install/provider.tf with your profile and region


This module is tested with Terraform version `1.9.x`.

The only supported configuration tiers are performance and balanced deployment types. Current support is 

- Performance deployment: Includes 3 instances.
- Balanced deployment: Includes 5 instances.
- If the multi_az flag is set to true, the balanced deployment supports 6 instances. Two instances in each AZ.

### AMI Availability

The AMI required in this module may not be available in all availability zones of AWS. Please, verify availability before starting.

### Supported AWS Instance Types and Storage Requirements

#### Deployment Types and Instance Types

- **Deployment type: performance**:
  - Supported Instance Types: `i3en.metal` (Single AZ), `i3en.12xlarge` (Multi AZ)
- **Deployment type: balanced**:
  - Supported Instance Types: `c5n.9xlarge`
  - Storage: 500GB, 1TB, 2TB, 4TB per disk and 10 disks per node

Ensure that the instance types and storage configurations match the requirements for your specific deployment type to optimize performance and cost-efficiency.


## Usage

1. Get the module to your local machine. To use this module, include it in your Terraform configuration as shown on terraform registry page for the module. 

2. Navigate to code examples folder.
   ```
   cd examples/aws_install
   ```
4. Authenticate with AWS account and profile
   ```
   aws sso login --profile <YourProfileName>
   ```

5. Create the terraform.tfvars file using sample file provided. Check individual module documentation to adjust any other variables values and update main.tf if required.

6. Update provider.tf with your profile and region.

#### Key Points:

- **Source and Version**: Specify the module source and version properly.
- **Variables**: Include all required variables with appropriate values.
- **Example Configuration**: Refer a complete example to help understand how to use the module.
- **Inputs and Outputs**: Refer README.md for all inputs and outputs for clarity.

5. Initialize the Terraform working directory.
     ```
     terraform init -upgrade
     ```
6. Review the Terraform plan to see the changes that will be made.
     ```
    terraform plan -out main.tfplan
     ```
7. Apply the Terraform configuration to deploy Dell Apex Block storage.
     ````
    terraform apply main.tfplan
     ````

8. Once the instances are created, you can verify them using the AWS Management Console or the AWS CLI.
9. See Monitor Installation below for instructions.

10. You can access Apex block cluster (PowerFlex Manager UI) using the load balancer IP.
   1.  PowerFlex UI default credentials admin / Admin123! ... you will be asked to change the password.

11. Once the install is complete, you have the option to terminate installer ec2 instance after successful installation is done, as the installer is no longer needed.

## Monitor Installation
After the initial Terraform IaC completes, and the output configuration is returned, the installer IP can be used to monitor the complete deployment. The APEX Block management plane (PFMP) deployment will execute for a couple hours.

The log to monitor is named bedrock.log

1.    Establish an ssh connection from the bastion or a machine that can connect to the installer IP address.
2. cd into /tmp directoy where the id_rsa key resides.
3. ssh with ec2-user. Example where installer_IP = 10.0.0.21
```
ssh -i "id_rsa" ec2-user@10.0.0.21
```
4. Tail the log from this location. PFMP directoy will change over time. Confirm the proper location.
```
tail -f /tmp/bundle/pfmp_deployments/PFMP2-4.6.0.0-1258/logs/atlantic/bedrock.log
```

## Configuration

The Terraform configuration files in this repository are organized in the following way:

- `main.tf`: The main Terraform configuration file.
- `variables.tf`: The variables file, where you can define variables to customize the configuration.
- `provider.tf`: The provider file, where you can define aws configuration.

You can modify the configuration in the `terraform.tfvars` file to customize the creation. For example, you can change the AMI ID, instance type, creator etc.
You can modify `main.tf` if you don't want to run any specific module.

## Cleaning Up

To clean up the created resources, you can use the following command:
Option to use --auto-approve when no additional confirmation is necessary before destroy
```
terraform destroy --auto-approve
```
## Verification

To verify the successful installation, open your web browser and navigate to the load balancer's IP address. You should see the default web page or application interface indicating that the setup is complete.

Example:
`https://<load_balancer_ip>`

Replace `<load_balancer_ip>` with the actual IP address of your load balancer displayed in the output after successful `terraform apply`. OR you can find it out from your AWS console.

## Further Management of Apex Block Storage

For more information on how to manage Apex Block Storage using the `terraform-provider-powerflex`, please refer to the [official documentation](https://github.com/dell/terraform-provider-powerflex/blob/main/README.md). You may need to use Terraform providers from the jump host.

## Troubleshooting

### EC2 failures

1. **EC2 Instance Creation Fails**
   - **Error**: `Error launching source instance: UnauthorizedOperation: You are not authorized to perform this operation.`
   - **Solution**: Ensure that your AWS credentials have the necessary permissions to create EC2 instances and you are logged in. Check your IAM policies and roles.

2. **EBS Volume Attachment Issues**
   - **Error**: `Error attaching EBS volume: VolumeInUse: vol-xxxxxx is already attached to an instance.`
   - **Solution**: Verify that the EBS volume of same name is not already attached to another instance. Use the AWS Management Console or CLI to detach the volume if necessary.

3. **Instance and Volume Recreation**
   - **Issue**: EC2 instances and EBS volumes can not be attached.
   - **Solution**: Ensure that you have access to the zone specified for the subnet.

### Remote Provisioners

1. **Provisioner Script Fails to Execute**
   - **Error**: `Error running command '...': exit status 1.`
   - **Solution**: Check the script for syntax errors or missing dependencies. Ensure that the instance has the necessary permissions and network access to execute the script. In some cases, execute `dos2unix` on .tf and .sh files.

2. **Timeout Issues**
   - **Error**: `Error waiting for instance (i-xxxxxx) to become ready: timeout while waiting for state to become 'running'.`
   - **Solution**: Make sure that instance is still reachable. Increase or add the `timeout` value in the failing provisioner configuration. For example:

     ```hcl
     provisioner "remote-exec" {
       connection {
         type        = "ssh"
         user        = "ubuntu"
         private_key = file("~/.ssh/id_rsa")
         host        = self.public_ip
       }

       inline = [
         "sudo apt-get update",
         "sudo apt-get install -y nginx"
       ]

       timeout = "10m"
     }
     ```

### Bastion Host

1. **Connection Issues to Bastion Host**
   - **Error**: `ssh: connect to host bastion.example.com port 22: Connection timed out.`
   - **Solution**: Ensure that the security group associated with the bastion host allows inbound SSH traffic from your IP address. Verify the bastion host's IP and DNS settings.

2. **Provisioning Scripts Fail on Bastion Host**
   - **Error**: `Error running command '...': exit status 1.`
   - **Solution**: Ensure that the script and user has the correct permissions and that the necessary software is installed on the bastion host.

### Deployment failures

1. **Connection Issues in deployment**
   - **Error**: `DNS: errors in resolving hostnames or in getting hostnames.`
   - **Solution**: Ensure that the security group associated has access to all nodes in cidr. VPC's hostname settings are selected while creating.

   - **Error**: `ssh: errors in connecting to Installer.`
   - **Solution**: Verify that the security group allows access to all nodes within the specified CIDR. Ensure the CIDR value defined in the variable matches the subnet’s CIDR.

   - **Error**: `deployment failure.`
   - **Solution**: Verify that all ec2 instances created are healthy and reachable through ssh using the key specified in terraform configuration. Verify that security group created allows access to all instances, ssh and https ports. Review IAM roles and permissions. Inspect network configurations. After resolving all issues, destroy and redeploy.


### General Tips

- **Validate Configuration**: Always run `terraform validate` or `terraform plan` to check for syntax errors and configuration issues before applying changes.
- **Validate AWS Configuration**: Validate that parameters passed are valid and have properly configured on AWS.
- **Check Logs**: Review the Terraform logs and Apex block installer logs for detailed error messages and troubleshooting information.
- **Update Providers**: Ensure that you are using the latest version of the Terraform AWS provider to benefit from bug fixes and new features.
- **Apex Block Logs**: Find the installer IP either from the terraform log or from AWS console.

For more detailed troubleshooting steps, refer to the respective Dell, Terraform, AWS documentation.