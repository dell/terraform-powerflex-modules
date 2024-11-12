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
private_key=$1
username=$2
disk_mapping=$(ssh -o 'StrictHostKeyChecking no' -i $private_key $username@$3 "bash -s" < ./get_nvme_disks.sh)
echo $disk_mapping
COUNTER=1
sed -e "s:DEVICE_MAPPING$COUNTER:\"$disk_mapping\":g" ./CSV_basic.csv > ./temp$COUNTER.csv
for var in "${@:4}"
do
    echo $var
    TEMP_COUNTER=$(( COUNTER + 1 ))
    disk_mapping=$(ssh -o 'StrictHostKeyChecking no' -i $private_key $username@$var "bash -s" < ./get_nvme_disks.sh)
    sed -e "s:DEVICE_MAPPING$TEMP_COUNTER:\"$disk_mapping\":g"  ./temp$COUNTER.csv > ./temp$TEMP_COUNTER.csv
    COUNTER=$(( COUNTER + 1 ))
done
cat ./temp$COUNTER.csv > ./CSV_basic.csv
rm -rf ./temp*