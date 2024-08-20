---
title: "User"
linkTitle: "User"
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
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.1 |
| <a name="requirement_powerflex"></a> [powerflex](#requirement\_powerflex) | 1.2.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_user_creation"></a> [user\_creation](#module\_user\_creation) | ../../modules/user | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_endpoint"></a> [endpoint](#input\_endpoint) | Stores the endpoint of PowerFlex host. eg: https://10.1.1.1:443, here 443 is port where API requests are getting accepted | `string` | n/a | yes |
| <a name="input_mdmHost"></a> [mdmHost](#input\_mdmHost) | Primary MDM host required for connecting to the Primary MDM. | `string` | n/a | yes |
| <a name="input_mdmPassword"></a> [mdmPassword](#input\_mdmPassword) | Primary MDM password required for connecting to the Primary MDM. | `string` | n/a | yes |
| <a name="input_mdmUserName"></a> [mdmUserName](#input\_mdmUserName) | Primary MDM username required for connecting to the Primary MDM. | `string` | n/a | yes |
| <a name="input_newPassword"></a> [newPassword](#input\_newPassword) | New password required for the first login. | `string` | n/a | yes |
| <a name="input_newUserName"></a> [newUserName](#input\_newUserName) | Name of the new user. | `string` | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | Stores the password of PowerFlex host. | `string` | n/a | yes |
| <a name="input_userPassword"></a> [userPassword](#input\_userPassword) | Password of the new user. | `string` | n/a | yes |
| <a name="input_userRole"></a> [userRole](#input\_userRole) | Role of the new user. | `string` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | Stores the username of PowerFlex host. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->