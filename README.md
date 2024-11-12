<!--
Copyright (c) 2023-2024 Dell Inc., or its subsidiaries. All Rights Reserved.

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
# Terraform Modules for Dell Technologies PowerFlex

[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg)](about/CODE_OF_CONDUCT.md)
[![License](https://img.shields.io/badge/License-MPL_2.0-blue.svg)](LICENSE)

Terraform modules package multiple resources together, allowing for efficient, modular design. They simplify code management and can be easily shared across different projects. For more information refer this [link](https://developer.hashicorp.com/terraform/language/modules) 

In this release, we are introducing Terraform modules for the purpose of user management.

## Table of contents

* [Code of Conduct](https://github.com/dell/dell-terraform-providers/blob/main/docs/CODE_OF_CONDUCT.md)
* [Maintainer Guide](https://github.com/dell/dell-terraform-providers/blob/main/docs/MAINTAINER_GUIDE.md)
* [Committer Guide](https://github.com/dell/dell-terraform-providers/blob/main/docs/COMMITTER_GUIDE.md)
* [Contributing Guide](https://github.com/dell/dell-terraform-providers/blob/main/docs/CONTRIBUTING.md)
* [List of Adopters](https://github.com/dell/dell-terraform-providers/blob/main/docs/ADOPTERS.md)
* [Support](#support)
* [Security](https://github.com/dell/dell-terraform-providers/blob/main/docs/SECURITY.md)
* [License](#license)
* [Prerequisites](#prerequisites)
* [List of Submodules in Terraform Modules for Dell PowerFlex](#list-of-submodules-in-terraform-modules-for-dell-powerflex)

## Support
For any Terraform Modules for Dell PowerFlex issues, questions or feedback, please follow our [support process](https://github.com/dell/dell-terraform-providers/blob/main/docs/SUPPORT.md)

## License
The Terraform Modules for Dell PowerFlex is released and licensed under the MPL-2.0 license. See [LICENSE](LICENSE) for the full terms.

## Prerequisites

| **Terraform Provider** | **PowerFlex/VxFlex OS Version** | **OS** | **Terraform** | **Golang** |
|------------------------|---------------------------------|--------|---------------|------------|
| >= v1.5.0              | >= 3.6        | ubuntu22.04 <br> rhel9.x | >= 1.5        | 1.22.x

## List of Submodules in Terraform Modules for Dell PowerFlex
  * [User](modules/user/README.md)
  * [SDC Linux](https://registry.terraform.io/modules/dell/modules/powerflex/latest/submodules/sdc_host_linux)
  * [SDC ESXi](https://registry.terraform.io/modules/dell/modules/powerflex/latest/submodules/sdc_host_esxi)
  * [SDC Windows](https://registry.terraform.io/modules/dell/modules/powerflex/latest/submodules/sdc_host_win)
  * [vSphere OVA Deployment](https://registry.terraform.io/modules/dell/modules/powerflex/latest/submodules/vsphere-ova-vm-deployment)
  * [Powerflex Management Installer EXSi](https://registry.terraform.io/modules/dell/modules/powerflex/latest/submodules/vsphere_pfmp_installation)
  * [Azure Block Storage Deployment](https://registry.terraform.io/modules/dell/modules/powerflex/latest/submodules/azure_pfmp)
  * [AWS Block Storage Infrastructure](https://registry.terraform.io/modules/dell/modules/powerflex/latest/submodules/aws_infra)
  * [AWS Block Storage Deployment](https://registry.terraform.io/modules/dell/modules/powerflex/latest/submodules/aws_install)