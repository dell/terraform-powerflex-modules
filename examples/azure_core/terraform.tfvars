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

username = ""
password = ""
endpoint = "https://10.2.0.200"
insecure = true
login_credential = {
  username = ""
  password = ""
}
sds_ips         = ["10.2.0.4", "10.2.0.5", "10.2.0.6", "10.2.0.7", "10.2.0.8"]
data_disk_count = 20
is_multi_az     = false
is_balanced     = true

# Uncomment if to use PowerFlex 4.5.2
# packages = [
#   "/root/PowerFlex_4.5.2000.135_SLES15.4/EMC-ScaleIO-lia-4.5-2000.135.sles15.4.x86_64.rpm",
#   "/root/PowerFlex_4.5.2000.135_SLES15.4/EMC-ScaleIO-mdm-4.5-2000.135.sles15.4.x86_64.rpm",
#   "/root/PowerFlex_4.5.2000.135_SLES15.4/EMC-ScaleIO-sdr-4.5-2000.135.sles15.4.x86_64.rpm",
#   "/root/PowerFlex_4.5.2000.135_SLES15.4/EMC-ScaleIO-sds-4.5-2000.135.sles15.4.x86_64.rpm",
#   "/root/PowerFlex_4.5.2000.135_SLES15.4/EMC-ScaleIO-sdt-4.5-2000.135.sles15.4.x86_64.rpm",
#   "/root/PowerFlex_4.5.2000.135_SLES15.4/EMC-ScaleIO-activemq-5.18.3-66.noarch.rpm"
# ]
