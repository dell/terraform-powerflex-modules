---
title: "Windows SDC"
linkTitle: "Windows SDC"
description: PowerFlex Terraform module
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

# SDC Host Module

This Terraform module installs the SDC package on a remote Windows host using the `powerflex_sdc_host` resource.
It downloads the package either on local machine or remote (Windows) machine and deploys on Windows.

## Example

main.tf
```hcl
terraform {
  required_providers {
    powerflex = {
      version = ">=1.6.0"
      source  = "registry.terraform.io/dell/powerflex"
      }
    }
}

module "sdc_host_win" {
  source = "dell/modules/powerflex//modules/sdc_host_win"
  version = "x.x.x" //Grab the latest but for example 1.2.0
  
  name = "terraform-windows-sdc" // Update to the value you wish to name your SDC
  ip = "x.x.x.x" // Update to the IP of the VM which you want to install your SDC packages upon 
  remote_host = {
    user = "example-user" // Update to the username used to access the windows VM
    password = "example-password" // Update to the password used ot access the windows VM 
  }
  sdc_name = "terraform-sdc"// The name of the SDC will default to 'terraform-sdc'
  sdc_pkg = {
    url = "http://example.com/EMC-ScaleIO-sdc-4.6-x.x.msi" // URL to place where the sdc.msi file is hosted FTP Example: "ftp://username:password@ftpserver/path/to/EMC-ScaleIO-sdc-4.6-x.x.msi" # the name of the SDC package saved in local directory.
    pkg_name = "EMC-ScaleIO-sdc-4.6-x.x.msi" 
    local_dir = "/tmp" // Where the sdc_pkg will be downloaded
    use_remote_path = false // download and use the SDC package on remote machine path (where SDC is going to be deployed)
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_powerflex"></a> [powerflex](#requirement\_powerflex) | >=1.6.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_sdc_host_win"></a> [sdc\_host\_win](#module\_sdc\_host\_win) | ../../modules/sdc_host_win | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ip"></a> [ip](#input\_ip) | Stores the IP address of the remote Windows host. | `string` | n/a | yes |
| <a name="input_mdm_ips"></a> [mdm\_ips](#input\_mdm\_ips) | all the mdms (either primary,secondary or virtual ips) in a comma separated list by cluster if unset will use the mdms of the cluster set in the provider block eg. ['10.10.10.5,10.10.10.6', '10.10.10.7,10.10.10.8'] | `list(string)` | `[]` | no |
| <a name="input_remote_host"></a> [remote\_host](#input\_remote\_host) | Stores the credentials for connecting to the remote Windows host. | <pre>object({<br>    # Define the `user` attribute of the `remote` variable.<br>    user = string<br>    password = string<br>  })</pre> | n/a | yes |
| <a name="input_sdc_pkg"></a> [sdc\_pkg](#input\_sdc\_pkg) | configuration for SDC package like url to download package from, copy as local package or at directory on remote server. | <pre>object({<br>    # examples "http://example.com/EMC-ScaleIO-sdc-3.6-700.103.msi", "ftp://username:password@ftpserver/path/to/file"<br>    url = string<br>    # the name of the SDC package saved in local directory.<br>    pkg_name = string<br>    # the local directory where the SDC package will be downloaded.<br>    local_dir = string<br>    # download and use the SDC package on remote machine path (where SDC is going to be deployed)<br>    use_remote_path = bool<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->