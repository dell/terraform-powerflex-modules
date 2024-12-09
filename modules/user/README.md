<!--
Copyright (c) 2023 Dell Inc., or its subsidiaries. All Rights Reserved.

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
# user

Manages user on a PowerFlex array. User resource can be used to create, update role and delete the user from the PowerFlex array. Once the user is created, it is mandatory to change the password when it's logged in for the first time. The intent of this user submodule is to change the password during it's first login.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) |  >= 1.5 |
| <a name="requirement_powerflex"></a> [powerflex](#requirement\_powerflex) | >= 1.2.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) |  3.2.1 |   

## Providers

| Name | Version |
|------|---------|
| <a name="provider_powerflex"></a> [powerflex](#provider\_powerflex) | >= 1.2.0 |
| <a name="provider_null"></a> [null](#provider\_null) |  3.2.1 |   

## Schema

### Inputs

- `username` (String) Stores the username of PowerFlex host.
- `password` (String) Stores the password of PowerFlex host.
- `endpoint` (String) Stores the endpoint of PowerFlex host.
- `newUserName` (String) The name of the user.
- `userPassword` (String) Password of the user.
- `userRole` (String) The role of the user. Accepted values are 'Administrator', 'Monitor', 'Configure', 'Security', 'FrontendConfig', 'BackendConfig'.
- `mdmUserName` (String) Primary MDM username required for connecting to the Primary MDM.
- `mdmPassword` (String) Primary MDM password required for connecting to the Primary MDM.
- `mdmHost` (String) Primary MDM host required for connecting to the Primary MDM.
- `newPassword` (String) New password required for the first login

### Outputs

- `new_user_id` (String) ID of the newly created user
- `new_username` (String) Name of the newly created user
- `new_user_role` (String) Role of the newly created user

### Prerequisites

User module can only be used with terraform provider powerflex >= v1.2.0

### Usage

Please refer the User example [here](https://github.com/dell/terraform-powerflex-modules/blob/main/examples/user/README.md)
After providing proper values to all the attributes, then in that workspace, run

```
terraform init
terraform apply
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.1 |
| <a name="requirement_powerflex"></a> [powerflex](#requirement\_powerflex) | 1.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.1 |
| <a name="provider_powerflex"></a> [powerflex](#provider\_powerflex) | 1.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.provision](https://registry.terraform.io/providers/hashicorp/null/3.2.1/docs/resources/resource) | resource |
| powerflex_user.newUser | resource |

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

| Name | Description |
|------|-------------|
| <a name="output_new_user_id"></a> [new\_user\_id](#output\_new\_user\_id) | n/a |
| <a name="output_new_user_role"></a> [new\_user\_role](#output\_new\_user\_role) | n/a |
| <a name="output_new_username"></a> [new\_username](#output\_new\_username) | n/a |
<!-- END_TF_DOCS -->