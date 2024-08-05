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

SDC Host module can only be used with terraform provider PowerFlex v1.6.0 and above.

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
