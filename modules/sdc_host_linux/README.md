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

# SDC Host Module for Linux

This Terraform module installs the SDC package on a remote Linux host using the `powerflex_sdc_host` resource.

### Prerequisites

SDC Host module can only be used with terraform provider PowerFlex v1.6.0 and above.

For SELinux configration, refer to "Configure the SDC (scini) driver for SELinux" section in PowerFlex Install/Upgrade guide.

***Note**: VM should have the following packages **installed fio sshpass unzip yum-utils wget gcc make***

## Usage

main.tf for Ubuntu
```hcl
terraform {
  required_providers {
    powerflex = {
      version = ">=1.6.0"
      source  = "registry.terraform.io/dell/powerflex"
      }
    }
}

module "sdc_host" {

  # Here is an example of a source that pulls from the registry
  source  = "dell/modules/powerflex//modules/sdc_host_linux"
  version = "x.x.x" // pull in the latest version like "1.2.0"

  remote_host = { // Stores the SSH credentials for connecting to the remote Linux host.
      user = "root"
      password = "password"
  }


  ip="1.2.11.4" //Stores the IP address of the remote Linux host.
  versions={
      pflex = "4.5.3000.118"
      kernel = "5.15.0-1-generic"
  }
  scini = {
      url = "" // leave as empty for autobuild = true
      linux_distro = "Ubuntu"
      autobuild_scini = true // allow to build scini on destination machine. This may not work on PowerFlex v3.X. Prerequisites here https://www.dell.com/support/kbdoc/en-us/000224134/how-to-on-demand-compilation-of-the-powerflex-sdc-driver 
  }

  sdc_pkg = {
      url = "http://example.com/release/SIGNED/EMC-ScaleIO-sdc-4.5-3000.118.Ubuntu.22.04.x86_64.tar"
      local_dir = "/tmp"
      remote_pkg_name = "emc-sdc-package.tar" // Dont update this, It should be emc-sdc-package.tar
      remote_dir = "/tmp" // temp directory on the SDC host
      remote_file = "EMC-ScaleIO-sdc-4.5-3000.118.Ubuntu.22.04.x86_64.tar" // name of file once downloaded on to remote should match what is being downloaded from sdc_pkg
      use_remote_path = true // Leave this as true
      skip_download_sdc = false // Leave this as false
  }
  mdm_ips = [] // If only attaching to one cluster then leave as empty list [] and the default virtual ips will be picked up. If wanting to attach to more then one cluster, give the mdm ips in a fomat like so provider block eg. ['10.10.10.5,10.10.10.6', '10.10.10.7,10.10.10.8']
}
```

main.tf for RHEL9
```hcl
terraform {
  required_providers {
    powerflex = {
      version = ">=1.6.0"
      source  = "registry.terraform.io/dell/powerflex"
      }
    }
}

module "sdc_host" {

  # Here is an example of a source that pulls from the registry
  source  = "dell/modules/powerflex//modules/sdc_host_linux"
  version = "x.x.x" // pull in the latest version like "1.2.0"

  remote_host = { // Stores the SSH credentials for connecting to the remote Linux host.
      user = "root"
      password = "password"
  }


  ip="1.2.11.4" //Stores the IP address of the remote Linux host.
  versions={
      pflex = "4.5.3000.118"
      kernel = "5.15.0-1-generic"
  }
  scini = {
      url = "" // leave as empty for autobuild = true
      linux_distro = "RHEL9"
      autobuild_scini = true // allow to build scini on destination machine. This may not work on PowerFlex v3.X. Prerequisites here https://www.dell.com/support/kbdoc/en-us/000224134/how-to-on-demand-compilation-of-the-powerflex-sdc-driver 
  }

  sdc_pkg = {
      url = "http://example.com/release/SIGNED/EMC-ScaleIO-sdc-4.5-3000.118.Ubuntu.22.04.x86_64.rpm"
      local_dir = "/tmp"
      remote_pkg_name = "emc-sdc-package.rpm" // Dont update this, It should be emc-sdc-package.rpm
      remote_dir = "/tmp" // temp directory on the SDC host
      remote_file = "EMC-ScaleIO-sdc-4.5-3000.118.Ubuntu.22.04.x86_64.rpm" // name of file once downloaded on to remote should match what is being downloaded from sdc_pkg
      use_remote_path = true // Leave this as true
      skip_download_sdc = false // Leave this as false
  }
  mdm_ips = [] // If only attaching to one cluster then leave as empty list [] and the default virtual ips will be picked up. If wanting to attach to more then one cluster, give the mdm ips in a fomat like so provider block eg. ['10.10.10.5,10.10.10.6', '10.10.10.7,10.10.10.8']
}
```

Please refer the SDC Host example [here](https://github.com/dell/terraform-powerflex-modules/blob/main/examples/sdc_host_linux/README.md)
After providing proper values to all the attributes eg. using terraform.tfvars, then in that workspace, run

```
terraform init
terraform apply
```
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_powerflex"></a> [powerflex](#requirement\_powerflex) | >=1.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_powerflex"></a> [powerflex](#provider\_powerflex) | >=1.6.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| powerflex_sdc_host.sdc_local_path | resource |
| powerflex_sdc_host.sdc_remote_path | resource |
| [terraform_data.compare_version](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [terraform_data.linux_scini](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [terraform_data.linux_scini_auto](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [terraform_data.sdc_pkg_local](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [terraform_data.sdc_pkg_remote](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [local_sensitive_file.ssh_cert](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/sensitive_file) | data source |
| [local_sensitive_file.ssh_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/sensitive_file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ip"></a> [ip](#input\_ip) | Stores the IP address of the remote Linux host. | `string` | n/a | yes |
| <a name="input_mdm_ips"></a> [mdm\_ips](#input\_mdm\_ips) | all the mdms (either primary,secondary or virtual ips) in a comma separated list by cluster if unset will use the mdms of the cluster set in the provider block eg. ['10.10.10.5,10.10.10.6', '10.10.10.7,10.10.10.8'] | `list(string)` | n/a | yes |
| <a name="input_remote_host"></a> [remote\_host](#input\_remote\_host) | Stores the SSH credentials for connecting to the remote Linux host. | <pre>object({<br>    # Define the `user` attribute of the `remote` variable.<br>    user = string<br>    # Define the ssh `private_key` file with path for the SDC login user<br>    private_key = optional(string, "")<br>    # Define the ssh `certificate` file path, issued to the SDC login user<br>    certificate = optional(string, "")<br>    password = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_scini"></a> [scini](#input\_scini) | The SCINI module package related variables. | <pre>object({<br>    # The URL where the SCINI module package is located. Ignored if autobuild_scini is true.<br>    url = optional(string)<br>    # specify distro where SDC will be deployed eg. RHEL9, Ubuntu etc. as case sensitive<br>    linux_distro = string<br>    #allow to build scini on destination machine. This may not work on PowerFlex v3.X. Prerequisites here https://www.dell.com/support/kbdoc/en-us/000224134/how-to-on-demand-compilation-of-the-powerflex-sdc-driver <br>    autobuild_scini = optional(bool, false)<br>  })</pre> | n/a | yes |
| <a name="input_sdc_pkg"></a> [sdc\_pkg](#input\_sdc\_pkg) | configuration for SDC package like url to download package from, copy as local package or directory on remote server. One of local\_dir or remote\_dir will be used based on the variable use\_remote\_path | <pre>object({<br>    # examples "http://example.com/EMC-ScaleIO-sdc-3.6-700.103.Ubuntu.22.04.x86_64.tar", "ftp://username:password@ftpserver/path/to/file"<br>    url = optional(string)<br>    #the name of the SDC package for local.<br>    pkg_name = optional(string)<br>    #the name of the SDC package for remote machine. It should be emc-sdc-package.(tar/rpm)<br>    remote_pkg_name = optional(string)<br>    #local directory where the SDC package will be downloaded.<br>    local_dir = optional(string)<br>    #remote directory where the SDC package will be downloaded. (if use_remote_path is true)<br>    remote_dir = optional(string, "/tmp")<br>    # use the SDC package on remote machine path (where SDC is deployed)<br>    use_remote_path = bool<br>    # if SDC package is available in local directory, download can be skipped by setting to true<br>    skip_download_sdc = optional(bool, false)<br>  })</pre> | n/a | yes |
| <a name="input_versions"></a> [versions](#input\_versions) | n/a | <pre>object({<br>    pflex = string<br>    kernel = string<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->