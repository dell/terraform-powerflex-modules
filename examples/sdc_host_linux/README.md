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
scini_url="http://example.com/sw_dev/Artifacts/Build-All-Ubuntu22.04/3.6.700.103/release/5.15.0-112-generic"
versions={
    pflex = "3.6.700.103"
    kernel = "5.15.0-112-generic"
}

sdc_pkg = {
    url = "http://example.com/release/SIGNED/EMC-ScaleIO-sdc-3.6-700.103.Ubuntu.22.04.x86_64.tar"
    local_pkg = "EMC-ScaleIO-sdc-3.6-700.103.Ubuntu.22.04.x86_64.tar"
    local_dir = "/tmp"
    pkg_name = "EMC-ScaleIO-sdc-3.6-700.103.Ubuntu.22.04.x86_64.tar"
    remote_pkg_name = "emc-sdc-package.tar"
    remote_dir = "/tmp"
    remote_file = "EMC-ScaleIO-sdc-3.6-700.103.Ubuntu.22.04.x86_64.tar"
    use_remote_path = false
}

powerflex_config = {
    username = "admin"
    endpoint = "https://1.2.3.4:443"
    password = "Password" 
}
```

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
| <a name="module_sdc_host_linux"></a> [sdc\_host\_linux](#module\_sdc\_host\_linux) | ../../modules/sdc_host_linux | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ip"></a> [ip](#input\_ip) | Stores the IP address of the remote Linux host. | `string` | n/a | yes |
| <a name="input_mdm_ips"></a> [mdm\_ips](#input\_mdm\_ips) | all the mdms (either primary,secondary or virtual ips) in a comma separated list by cluster if unset will use the mdms of the cluster set in the provider block eg. ['10.10.10.5,10.10.10.6', '10.10.10.7,10.10.10.8'] | `list(string)` | `[]` | no |
| <a name="input_powerflex_config"></a> [powerflex\_config](#input\_powerflex\_config) | Stores the configuration for terraform PowerFlex provider. | <pre>object({<br>    # Define the attributes of the configuration for terraform PowerFlex provider.<br>    username = string<br>    endpoint = string<br>    password = string<br>  })</pre> | n/a | yes |
| <a name="input_remote_host"></a> [remote\_host](#input\_remote\_host) | Stores the SSH credentials for connecting to the remote Linux host. | <pre>object({<br>    # Define the `user` attribute of the `remote` variable.<br>    user = string<br>    # Define the ssh `private_key` file with path for the SDC login user<br>    private_key = optional(string, "")<br>    # Define the ssh `certificate` file path, issued to the SDC login user<br>    certificate = optional(string, "")<br>    password = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_scini_url"></a> [scini\_url](#input\_scini\_url) | The URL where the SCINI module package is located. | `string` | n/a | yes |
| <a name="input_sdc_pkg"></a> [sdc\_pkg](#input\_sdc\_pkg) | configuration for SDC package like url to download package from, copy as local package or directory on remote server. One of local\_dir or remote\_dir will be used based on the variable use\_remote\_path | <pre>object({<br>    # examples "http://example.com/EMC-ScaleIO-sdc-3.6-700.103.Ubuntu.22.04.x86_64.tar", "ftp://username:password@ftpserver/path/to/file"<br>    url = string<br>    pkg_name = string<br>    remote_pkg_name = optional(string)<br>    local_dir = string<br>    remote_dir = optional(string, "/tmp")<br>    # use the SDC package on remote machine path (where SDC is deployed)<br>    use_remote_path = bool<br>  })</pre> | n/a | yes |
| <a name="input_versions"></a> [versions](#input\_versions) | n/a | <pre>object({<br>    pflex = string<br>    kernel = string<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->