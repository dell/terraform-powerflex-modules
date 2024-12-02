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

# Check if at least one IP address is provided
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <IP_ADDRESS1> [<IP_ADDRESS2> ...]"
  exit 1
fi

# Loop through the provided IP addresses and get the hostnames
for IP_ADDRESS in "$@"; do
  HOSTNAME=$(nslookup $IP_ADDRESS | grep 'name =' | awk '{print $4}')
  
  # Check if a hostname was found
  if [ -z "$HOSTNAME" ]; then
    HOSTNAME="$IP_ADDRESS"
  fi
  # Check if the hostname ends with a dot
  SANITIZED_HOSTNAME=$(echo "$HOSTNAME" | awk '{if (length($0) > 0 && substr($0, length($0), 1) == ".") {print substr($0, 1, length($0) - 1)} else {print $0}}')
  echo "$SANITIZED_HOSTNAME"
done
