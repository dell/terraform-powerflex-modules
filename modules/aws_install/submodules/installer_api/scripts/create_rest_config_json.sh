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
installer_ip=$1
ip1_new=$2
ip2_new=$3
ip3_new=$4
lb_IP_new=$5
host1=$6
host2=$7
host3=$8
sed -i '{:q;N;s/\n/\\\\n/g;t q}' ./core_deployment.csv
sed -i "s/\"/\\\\\\\\\"/g" ./core_deployment.csv
csv_template=`cat ./core_deployment.csv`
end=$(echo $installer_ip | cut -d"." -f4)
config_file="PF_Installer_$end.json"
cp ./PF_Installer_template.json ./$config_file
echo \"$csv_template\"
#host1=ip-$(echo ${ip1_new} | sed 's/\./-/g').ec2.internal
#host2=ip-$(echo ${ip2_new} | sed 's/\./-/g').ec2.internal
#host3=ip-$(echo ${ip3_new} | sed 's/\./-/g').ec2.internal
sed -i "s/IP1/${ip1_new}/g" ./$config_file
sed -i "s/IP2/${ip2_new}/g" ./$config_file
sed -i "s/IP3/${ip3_new}/g" ./$config_file
sed -i "s/node1/${host1}/g" ./$config_file
sed -i "s/node2/${host2}/g" ./$config_file
sed -i "s/node3/${host3}/g" ./$config_file
sed -i "s/lb_IP/${lb_IP_new}/g" ./$config_file
sed -i "s/dellpowerflex.com/${lb_IP_new}/g" ./$config_file
sed -i "s#core_csv_template#${csv_template}#g" ./$config_file
sed -i "s/<installer_ip>/${installer_ip}/g" ./run_installer.sh
sed -i "s/<installer_ip>/${installer_ip}/g" ./get_installer_status.sh

mv ./$config_file ./Rest_Config.json
