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

Manages user on a PowerFlex array.

## Schema

### Inputs

- `name` (String) The name of the user.
- `password` (String) Password of the user.
- `role` (String) The role of the user. Accepted values are 'Administrator', 'Monitor', 'Configure', 'Security', 'FrontendConfig', 'BackendConfig'.
- `user` (String) Primary MDM user for connection
- `password` (String) Primary MDM password for connection
- `host` (String) Primary MDM host for connection
- `changedpassword` (String) New password required for the first login

### Outputs

- `new_user_id` (String) ID of the newly created user
- `new_username` (String) Name of the newly created user
- `new_user_role` (String) Role of the newly created user

