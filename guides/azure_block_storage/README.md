---
title: "Apex Block for Azure module Guide"
linkTitle: "Apex Block for Azure module Guide"
description: PowerFlex Terraform Azure module Guide
weight: 2
---

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

## APEX Block Storage deployment on Microsoft Azure

This will guide you through how to deploy Dell APEX Block Storage for Microsoft Azure with terraform cli.

## Prerequisites
https://learn.microsoft.com/en-us/azure/developer/terraform/quickstart-configure

Required: terraform >= 1.5, azure cli, ssh key pair

#### Electronically sign and acknowledge the EULA
 - [Software Evaluation License Agreement](https://pact.ly/HJb2H-)

#### Install and Configure Terraform
- Configure in Azure Cloud Shell with Bash
- Configure in Azure Cloud Shell with PowerShell
- [Configure in Windows with Bash](https://learn.microsoft.com/en-us/azure/developer/terraform/get-started-windows-bash)
- Configure in Windows with PowerShell

#### Install Terraform on Windows with Bash

1. [Install the Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows)
2. [Authenticate Terraform to Azure](https://learn.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure?tabs=bash)
    - Authenticate with a Microsoft account using Cloud Shell (with Bash)
    - [Authenticate with a Microsoft account using Windows (with Bash)](https://learn.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure-with-microsoft-account)
    - [Authenticate with a service principal](https://learn.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure-with-service-principle?tabs=bash)
    - Authenticate with a managed identity for Azure services

#### Create an SSH key pair
https://learn.microsoft.com/en-us/viva/glint/setup/sftp-ssh-key-gen

## Deployment Tiers
Within examples/azure_pfmp/terraform.tfvars there is a deployment_type variable, defined as:
- balanced - Standard_F48s_v2 20 x 512 GiB (20 recommended for a base POC)
- optimized_v1 - Standard_L32as_v3 provides 4 x 1.92 TiB NVMe disks
- optimized_v2 - Standard_L64as_v3 provides 8 x 1.92 TiB NVMe disks


## Deployment Steps
It involves two parts to deploy Powerflex block storage in Azure environment.

**Note:** If your are using VS Code on a Windows OS, use a **Git Bash Terminal session** within VS Code for all of Step 1 listed below.

#### 1. Setup the azure infrastructure and install PowerFlex management platform

For this part, please run the following steps locally.

1. Authenticate with Microsoft azure account
    ```
    az login

    ## verify the result
    az account show
    ```
    
    Alternatively set the following environment variables for terraform if to authenticate with service principal, and sign in azure cli with service principal by running `az login --service-principal -u <client-id> -p <client-secret> --tenant <tenant>`

    - `ARM_SUBSCRIPTION_ID`
    - `ARM_TENANT_ID`
    - `ARM_CLIENT_ID`
    - `ARM_CLIENT_SECRET`

2. Initialize terraform
    ```
    cd examples/azure_pfmp
    terraform init -upgrade
    ```

3. Copy ssh key pair into `examples/azure_pfmp/ssh` with public key name of `azure.pem.pub` and private key name of `azure.pem`, adjust `terraform.tfvars` and create a terraform execution plan
    ```
    terraform plan -out main.tfplan
    ```

4. Apply the terraform execution plan
    ```
    terraform apply main.tfplan
    ```

    PS: Once the pfmp installation finishes, it will generate the `terraform.tfvars` file in the `/root` folder on **intaller** for part 2.
    
    Copy the `examples/azure_pfmp/ssh/azure.pem` file to your SSH connection location. Jump host as an example.
    
    You can SSH into the installer node with the .pem `ssh -i azure.pem pflexuser@<InstallerIP>`
    The installer IP address can be found within the Azure portal.
    
    As an additional SSH connection option, the username and password can be used. pflexuser/PowerFlex123! `ssh pflexuser@<InstallerIP>`

    You can track the bedrock log `tail -f /tmp/bundle/atlantic/logs/bedrock.log` for detailed progress.

    When step 1 is complete you can browse to the PowerFlex UI if desired.
    From the Azure portal, get the frontend load balancer IP address which will be the PowerFlex UI. Currently set as "https://10.2.0.200"
    
    PowerFlex UI default credentials
    admin / Admin123!    ... you will be asked to change the password.

#### 2. Deploy PowerFlex on installer

For this part, the following steps need to be executed inside of **installer**. As a second option, you can use the *az network bastion tunnel* steps defined in the Misc section below.

1. Check `/root` folder, make sure `terraform.tfvars` for PowerFlex core deployment has been automatically generated.

    ```
    sudo -i
    cd /root & ls
    ```

2. See below for the link to the PowerFlex software. Login required. The process will need the proper PowerFlex bits in the `/root` folder to continue.
   1. 4.5.1, 4.5.2, 4.6 are supported builds.
      1. 4.5.1 = 4.5.1000.103
      2. 4.5.2 = 4.5.2000.135
      3. 4.6.0 = 4.5.2100.105 (default build for this current Terraform)
   2. Extract Software_Only_Complete_4.6.0_105.zip
   3. Extract PowerFlex_4.5.2100.105_Complete_Core_SW.zip
   4. Extract and copy `PowerFlex_4.5.2100.105_SLES15.4.zip` to installer `/root` folder and unzip.

    ```
    unzip PowerFlex_4.5.2100.105_SLES15.4.zip
    cp -r PowerFlex_4.5.2100.105_SLES15.4 /root
    ```

3. Check out this repo, copy this repo to the installer, and initialize terraform

    ```
    cd examples/azure_core
    terraform init -upgrade
    ```

4. Copy `terraform.tfvars` and create a terraform execution plan
    ```
    cp /root/terraform.tfvars .
    terraform plan -out main.tfplan
    ```

5. Apply the terraform execution plan. This process will execute for roughly 5 minutes. +/-.
    ```
    terraform apply main.tfplan
    ```
   1. This step can be monitored via the PowerFlex Manager UI under Monitoring | Events

## Misc
1. [Accept marketplace terms](https://kb.brightcomputing.com/knowledge-base/azure-mp-terms/)

2. [Upload and download files via bastion tunnel](https://learn.microsoft.com/en-us/azure/bastion/vm-upload-download-native)
   
    ```
    az network bastion tunnel --name "<BastionName>" --resource-group "<ResourceGroupName>" --target-resource-id "<VMResourceId>" --resource-port "<TargetVMPort>" --port "<LocalMachinePort>"
    scp -P <LocalMachinePort>  <local machine file path>  <username>@127.0.0.1:<target VM file path>
    ```
   **Detailed steps** to use the *az network bastion tunnel*
   
    1. For the initial install, two files will need to be copied to the installer
       - PowerFlex_4.5.2100.105_SLES15.4.zip (current build default)
       - terraform-powerflex-modules-azure-block-storage.zip (this repo)
    2. Open the tunnel the with *az network bastion tunnel* output from the Terraform step 1 execution.
    3. Open a new connection and SSH into the installer using the pem file -i <PemFileLocation>: 
        ```
        ssh -p 1111 -i .ssh/azure.pem pflexuser@127.0.0.1
        ```
    4. You can now scp files directly into the installer with this tunnel. Open a new connection and scp the files to the installer. Transfer the two files and unzip within the installer when the transfers are complete. The scp connection will ask for the password.
        ```
        Example:   
        scp -P <LocalMachinePort> -i <PemFileLocation> <local machine file path>  <username>@127.0.0.1:<target VM file path>
    
        scp -P 1111 -i .ssh/azure.pem  "C:\temp\PowerFlex_4.5.2100.105_SLES15.4.zip" pflexuser@127.0.0.1:/home/pflexuser
        scp -P 1111  -i .ssh/azure.pem "C:\temp\terraform-powerflex-modules-azure-block-storage.zip" pflexuser@127.0.0.1:/home/pflexuser
        ```
    5. When the transfers are complete, copy the zip files to root. Use the previously opened ssh connection from step 3. The PWD should be `/home/pflexuser`
        ```
        sudo cp -r PowerFlex_4.5.2100.105_SLES15.4.zip /root
        sudo cp -r terraform-powerflex-modules-azure-block-storage.zip /root
        sudo -i
        cd /root & ls -l
        unzip PowerFlex_4.5.2100.105_SLES15.4.zip
        unzip terraform-powerflex-modules-azure-block-storage.zip
        ```
    6. Prepare Terraform execution - Change Directory
        ```
        cd terraform-powerflex-modules-azure-block-storage/examples/azure_core
        ```
    7. Copy the dynmically created terraform.tfvars into your PWD which is now `/azure_core`
        ```
        cp /root/terraform.tfvars .
        ```
    8. Terraform init
        ```
        terraform init -upgrade
        ```
    9. Create the Terraform plan
        ```
        terraform plan -out main.tfplan
        ```
    10. Apply the Terraform execution plan
        ```
        terraform apply main.tfplan
        ```
    11. This step can be monitored via the PowerFlex Manager UI under Monitoring | Events
    12. Close the bastion tunnel conection when terraform is complete

3. Tools
    - [Terraform v1.9.5](https://releases.hashicorp.com/terraform/1.9.5/terraform_1.9.5_linux_amd64.zip)
    - [MobaXterm v24.2](https://download.mobatek.net/2422024061715901/MobaXterm_Portable_v24.2.zip)
    - [WinSCP v6.3.5 (optional)](https://winscp.net/download/WinSCP-6.3.5-Setup.exe/download)
  
4. PFMP installation troubleshooting
    1. Try ssh connection within the docker container
        ```
        sudo docker exec -it atlantic_installer /bin/bash
        ssh pflexuser@yulan-balanced-vm-0
        ```
    2. Check PFMP installation log
        ```
        sudo docker container logs -f atlantic_installer
        ```

5. [PowerFlex Software](https://www.dell.com/support/home/en-us/product-support/product/scaleio/drivers)

    - [PowerFlex 4.5.2.1 Build 105 Complete Software Download. Publish date: 30 May 2024](https://dl.dell.com/downloads/C5D5T_PowerFlex-4.5.2.1-Build-105-Complete-Software-Download.zip)

6. [PowerFlex Documentation](https://www.dell.com/support/home/en-us/product-support/product/scaleio/docs)
      
   -  [APEX Block Storage for Azure: Management and Operations Guide](https://dl.dell.com/content/manual30516303-dell-apex-block-storage-for-microsoft-azure-with-powerflex-4-6-x-management-and-operations-guide.pdf?language=en-us)  
