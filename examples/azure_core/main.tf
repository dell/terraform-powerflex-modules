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

locals {
  ssd_list  = ["/dev/sdc", "/dev/sdd", "/dev/sde", "/dev/sdf", "/dev/sdg", "/dev/sdh", "/dev/sdi", "/dev/sdj", "/dev/sdk", "/dev/sdl", "/dev/sdm", "/dev/sdn", "/dev/sdo", "/dev/sdp", "/dev/sdq", "/dev/sdr", "/dev/sds", "/dev/sdt", "/dev/sdu", "/dev/sdv", "/dev/sdw", "/dev/sdx", "/dev/sdy", "/dev/sdz"]
  nvme_list = ["/dev/nvme0n1", "/dev/nvme1n1", "/dev/nvme2n1", "/dev/nvme3n1", "/dev/nvme4n1", "/dev/nvme5n1", "/dev/nvme6n1", "/dev/nvme7n1"]
  # For single az - node2: TB, node3: Secondary, node4: Primary, Fault Set: none
  # For multi az -  node3: Primary, node4: secondary, node5: TB, Fault Set: AZ(1,2,3)
  single_az_mdm_role_map = {
    2 = "TB",
    3 = "Secondary",
    4 = "Primary"
  }
  multi_az_mdm_role_map = {
    3 = "Primary",
    4 = "Secondary",
    5 = "TB"
  }
  mdm_role_map = var.is_multi_az ? local.multi_az_mdm_role_map : local.single_az_mdm_role_map
}

resource "powerflex_package" "packages" {
  file_path = var.packages
}

resource "powerflex_cluster" "pflex_cluster" {
  depends_on = [powerflex_package.packages]
  # Security Related Field
  mdm_password = "Password"
  lia_password = "Password"

  # Advance Security Configuration
  allow_non_secure_communication_with_lia = false
  allow_non_secure_communication_with_mdm = false
  disable_non_mgmt_components_auth        = false

  # Cluster Configuration related fields
  cluster = [
    for idx, ip in var.sds_ips : {
      # MDM Configuration Fields 
      username         = "${var.login_credential.username}(sudo)"
      password         = "${var.login_credential.password}"
      operating_system = "linux"
      is_mdm_or_tb     = lookup(local.mdm_role_map, idx, "")

      mdm_ips     = lookup(local.mdm_role_map, idx, "") != "" ? "${ip}" : null
      mdm_mgmt_ip = lookup(local.mdm_role_map, idx, "") != "" ? "${ip}" : null
      mdm_name    = lookup(local.mdm_role_map, idx, "") != "" ? "PowerFlexMDM_${idx}" : null

      # SDS Configuration Fields
      is_sds                  = "Yes"
      is_sdc                  = "No"
      sds_name                = "sds${idx + 1}"
      sds_all_ips             = "${ip}"
      protection_domain       = "${var.protection_domain}"
      sds_storage_device_list = var.is_balanced ? "${join(",", slice(local.ssd_list, 0, var.data_disk_count))}" : "${join(",", slice(local.nvme_list, 0, var.data_disk_count))}"
      storage_pool_list       = "${var.storage_pool}"
      perf_profile_for_mdm    = "HighPerformance"
      perf_profile_for_sds    = "HighPerformance"
      fault_set               = var.is_multi_az ? "AZ${(idx % 3) + 1}" : null
    }
  ]
  # Storage Pool Configuration Fields
  storage_pools = [
    {
      media_type        = "SSD"
      protection_domain = "${var.protection_domain}"
      storage_pool      = "${var.storage_pool}"
      zero_padding      = "Yes"
      data_layout       = "MG"
    }
  ]
}
