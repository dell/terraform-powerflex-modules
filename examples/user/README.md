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

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_powerflex"></a> [powerflex](#provider\_powerflex) | >= 1.2.0 |
| <a name="provider_null"></a> [null](#provider\_null) |  3.2.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_user"></a> [user](#module\user) | ../../modules/user | n/a |

## Resources

No resources.

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
<!-- END_TF_DOCS -->