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
terraform {
   required_providers {
     powerflex = {
       version = ">=1.6.0"
       source  = "registry.terraform.io/dell/powerflex"
     }
   }
 }

provider "powerflex" {
  username = var.powerflex_config.username
  password = var.powerflex_config.password
  endpoint = var.powerflex_config.endpoint
  insecure = true
  timeout  = 120
}
