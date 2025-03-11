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


##############
# PowerFlex SDC
##############

module "sdc_host_win" {
  # Here the source points to the a local instance of the submodule in the modules folder, if you have and instance of the modules folder locally.
  # source = "../../modules/sdc_host_win"

  # Here is an example of a source that pulls from the registry
  source  = "dell/modules/powerflex//modules/sdc_host_win"
  version = "x.x.x" // pull in the latest version like "1.2.0"

  ip = var.ip
  remote_host = var.remote_host
  sdc_pkg = var.sdc_pkg
  mdm_ips = var.mdm_ips
  sdc_name = "terraform-sdc"// The name of the SDC will default to 'terraform-sdc'
}

