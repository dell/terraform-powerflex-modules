<!--
Copyright (c) 2022 Dell Inc., or its subsidiaries. All Rights Reserved.

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
# Terraform Provider for Dell Technologies PowerFlex

[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg)](about/CODE_OF_CONDUCT.md)
[![License](https://img.shields.io/badge/License-MPL_2.0-blue.svg)](LICENSE)

The Terraform Modules for Dell Technologies (Dell) PowerFlex hosts terraform submodules 

The Terraform User Sub-module can be used to manage users for changing their password during the first login.

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
* [List of Submodules in Terraform Provider for Dell PowerFlex](#list-of-submodules-in-terraform-provider-for-dell-powerflex)

## Support
For any Terraform Provider for Dell PowerFlex issues, questions or feedback, please follow our [support process](https://github.com/dell/dell-terraform-providers/blob/main/docs/SUPPORT.md)

## License
The Terraform Provider for Dell PowerFlex is released and licensed under the MPL-2.0 license. See [LICENSE](LICENSE) for the full terms.

## Prerequisites

| **Terraform Provider** | **PowerFlex/VxFlex OS Version** | **OS** | **Terraform** | **Golang** |
|---------------------|-----------------------|-------|--------------------|--------------------------|
| v1.2.0 | 3.6 | ubuntu22.04 <br> rhel8.x <br> rhel9.x | 1.3.x <br> 1.5.x <br> | 1.20.x

## List of Submodules in Terraform Provider for Dell PowerFlex
  * [User](modules/user/README.md)