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

This Terraform module installs the SDC package on a remote Linux host using the `powerflex_sdc_host` resource.

## Variables

| Variable Name | Description |
|---------------|-------------|
| `ip` | Stores the IP address of the remote Linux host. |
| `remote_host` | Stores the SSH credentials for connecting to the remote Linux host. |
| `remote_host.user` | Stores the username for connecting to the remote Linux host. root will have all required privileges.|
| `remote_host.private_key` | Stores the SSH private key for connecting to the remote Linux host. |
| `remote_host.certificate` | Stores the SSH certificate for connecting to the remote Linux host. |
| `remote_host.password` | Stores the password for connecting to the remote Linux host. |
| `sdc_pkg` | Stores the SDC package information. |
| `sdc_pkg.url` | Stores the URL to download the SDC package from. eg. "http://example.com/path/to/file", "ftp://username:password@ftpserver/path/to/file"|
| `sdc_pkg.pkg_name` | Stores the name of the SDC package for local. |
| `sdc_pkg.remote_pkg_name` | Stores the name of the SDC package for remote machine. It should be emc-sdc-package.(tar/rpm)|
| `sdc_pkg.local_dir` | Stores the local directory where the SDC package will be downloaded. |
| `sdc_pkg.remote_dir` | Stores the remote directory where the SDC package will be downloaded. Dir should be present. |
| `sdc_pkg.use_remote_path` | Stores the flag to use the SDC package on a remote machine path or not. |
| `versions` | Stores the kernel and PowerFlex versions. |
| `scini_url` | The URL where the SCINI module package is located. |


### Prerequisites

SDC Host module can only be used with terraform provider PowerFlex v1.5.1 and above.

For SELinux configration, refer to "Configure the SDC (scini) driver for SELinux" section in PowerFlex Install/Upgrade guide.



## Usage

```hcl
module "sdc_host" {
  source = "./modules/sdc_host_linux"

  versions = var.versions
  ip = var.ip
  remote_host = var.remote_host
  scini_url = var.scini_url
  sdc_pkg = var.sdc_pkg
}
```

Please refer the SDC Host example [here](../../examples/sdc_host_linux/main.tf)
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
| <a name="input_scini_url"></a> [scini\_url](#input\_scini\_url) | The URL where the SCINI module package is located. | `string` | n/a | yes |
| <a name="input_sdc_pkg"></a> [sdc\_pkg](#input\_sdc\_pkg) | configuration for SDC package like url to download package from, copy as local package or directory on remote server. One of local\_dir or remote\_dir will be used based on the variable use\_remote\_path | <pre>object({<br>    # examples "http://example.com/EMC-ScaleIO-sdc-3.6-700.103.Ubuntu.22.04.x86_64.tar", "ftp://username:password@ftpserver/path/to/file"<br>    url = string<br>    pkg_name = string<br>    remote_pkg_name = optional(string)<br>    local_dir = string<br>    remote_dir = optional(string, "/tmp")<br>    # use the SDC package on remote machine path (where SDC is deployed)<br>    use_remote_path = bool<br>  })</pre> | n/a | yes |
| <a name="input_versions"></a> [versions](#input\_versions) | n/a | <pre>object({<br>    pflex = string<br>    kernel = string<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->