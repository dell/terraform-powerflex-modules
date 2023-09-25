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
# user

Manages user on a PowerFlex array. User resource can be used to create, update role and delete the user from the PowerFlex array. Once the user is created, it is mandatory to change the password when it's logged in for the first time. The intent of this user submodule is to change the password during it's first login.

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

User module can only be used with terraform provider powerflex v1.2.0

### Usage

Please refer the User example [here](../../examples/user/main.tf)
After providing proper values to all the attributes, then in that workspace, run

```
terraform init
terraform apply
```
