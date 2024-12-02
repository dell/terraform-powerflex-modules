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

COUNTER=0
cat  ./CSV_basic.csv > ./temp$COUNTER.csv

# Read the arguments 
while [ $# -gt 0 ]; do
  ip=$1
  nvme_input="$(cat ./nvme_disks_$ip.txt)"
  nvme_output=$(echo "$nvme_input" | sed 's/ //g')

  TEMP_COUNTER=$(( COUNTER + 1 ))
  sed "s/\\(IP$TEMP_COUNTER\\)/$ip/g" ./temp$COUNTER.csv >  ./temp$COUNTER_1.csv
  sed -e "s:DEVICE_MAPPING$TEMP_COUNTER:\"$nvme_output\":g"  ./temp$COUNTER_1.csv > ./temp$TEMP_COUNTER.csv
  COUNTER=$(( COUNTER + 1 ))
  shift 1
done
cat ./temp$COUNTER.csv > ./core_deployment.csv
rm -rf ./temp*
rm -f ./nvme_disks_*.txt