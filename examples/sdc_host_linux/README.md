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

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_sdc_host_linux"></a> [sdc\_host\_linux](#module\_sdc\_host\_linux) | ../../modules/sdc_host_linux | n/a |

## Resources

No resources.


<!-- END_TF_DOCS -->