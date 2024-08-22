---
title: "EXSi SDC"
linkTitle: "EXSi SDC"
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

# SDC Host Module for ESXi

This Terraform module installs the SDC package on a remote ESXi host using the `powerflex_sdc_host` resource.


## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform apply
```


After successful operation of above commands, to remove deployment, you need to execute:

```bash
terraform destroy 
```

## Example inputs

terraform.tfvars
```hcl
remote_host={
    user = "root"
    private_key = ""
    certificate = ""
    password = "password"
    }


ip="1.2.11.10"

sdc_pkg = {
    url = "https://example.com/sdc-4.5.0.263-esx8.x.zip"
    local_pkg = "sdc-4.5.0.263-esx8.x.zip"
    local_dir = "/tmp"
    pkg_name = "sdc-4.5.0.263-esx8.x.zip"
    remote_pkg_name = "emc-sdc-package.zip"
    remote_dir = "/tmp"
    use_remote_path = true
}

powerflex_config = {
    username = "admin"
    endpoint = "https://1.2.3.4:443"
    password = "Password" 
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
| <a name="module_sdc_host_esxi"></a> [sdc\_host\_esxi](#module\_sdc\_host\_esxi) | ../../modules/sdc_host_esxi | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ip"></a> [ip](#input\_ip) | Stores the IP address of the remote Linux host. | `string` | n/a | yes |
| <a name="input_mdm_ips"></a> [mdm\_ips](#input\_mdm\_ips) | all the mdms (either primary,secondary or virtual ips) in a comma separated list by cluster if unset will use the mdms of the cluster set in the provider block eg. ['10.10.10.5,10.10.10.6', '10.10.10.7,10.10.10.8'] | `list(string)` | `[]` | no |
| <a name="input_powerflex_config"></a> [powerflex\_config](#input\_powerflex\_config) | Stores the configuration for terraform PowerFlex provider. | <pre>object({<br>    # Define the attributes of the configuration for terraform PowerFlex provider.<br>    username = string<br>    endpoint = string<br>    password = string<br>  })</pre> | n/a | yes |
| <a name="input_remote_host"></a> [remote\_host](#input\_remote\_host) | Stores the SSH credentials for connecting to the remote Linux host. | <pre>object({<br>    # Define the `user` attribute of the `remote` variable.<br>    user = string<br>    # Define the ssh `private_key` file with path for the SDC login user<br>    private_key = optional(string, "")<br>    # Define the ssh `certificate` file path, issued to the SDC login user<br>    certificate = optional(string, "")<br>    password = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_sdc_pkg"></a> [sdc\_pkg](#input\_sdc\_pkg) | configuration for SDC package like url to download package from, copy as local package or directory on remote server. One of local\_dir or remote\_dir will be used based on the variable use\_remote\_path | <pre>object({<br>    # examples "http://example.com/EMC-ScaleIO-sdc-3.6-700.103.Ubuntu.22.04.x86_64.tar", "ftp://username:password@ftpserver/path/to/file"<br>    url = string<br>    pkg_name = string<br>    remote_pkg_name = optional(string)<br>    local_dir = string<br>    remote_dir = optional(string, "/tmp")<br>    # use the SDC package on remote machine path (where SDC is deployed)<br>    use_remote_path = bool<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->