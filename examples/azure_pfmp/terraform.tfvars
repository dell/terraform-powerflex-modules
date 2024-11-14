# /*
# Copyright (c) 2024 Dell Inc., or its subsidiaries. All Rights Reserved.

# Licensed under the Mozilla Public License Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://mozilla.org/MPL/2.0/


# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# */

### cluster
cluster_node_count      = 5          # Minimum of 5. If is_multi_az = true, then minimum of 6
deployment_type         = "balanced" # balanced, optimized_v1 or optimized_v2
enable_bastion          = true
enable_jumphost         = true
enable_sql_workload_vm  = false # If enabled, will deploy Standard_D4ds_v5.
existing_resource_group = null  # If null, a new RG will be created, else provide an existing "RG name"
is_multi_az             = false
location                = "eastus"
prefix                  = "tf-test"

### data disk
### the following value won't take effect on optimized_v1 and optimized_v2 deployment
### it will always be:
###     data_disk_count = 4 data_disk_size_gb=1966.08 for optimized_v1
###     data_disk_count = 8 data_disk_size_gb=1966.08 for optimized_v2
data_disk_count   = 20
data_disk_size_gb = 512
