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

#!/bin/bash
# shellcheck disable=SC2034
installer="<installer_ip>"

current_dir=$(basename "$PWD")
output_file="${current_dir: -3}.out"

while true; do
  # shellcheck disable=SC1073
  status=$(curl -k -s -X GET "https://${installer}:443/api/v1/install/status")
  is_in_progress=$(echo "$status" | grep IN_PROGRESS | wc -l)
  if [ "$is_in_progress" -ge 1 ]; then
    echo -e "`date` \t $status" >> ../$output_file
    sleep 10
  else
    break
  fi
done

# last one
status=$(curl -k -s -X GET "https://${installer}:443/api/v1/install/status")
echo -e "`date` \t $status" >> ../$output_file
echo
