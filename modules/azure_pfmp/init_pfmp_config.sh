#!/bin/bash

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

echo "net.ipv4.ip_forward=1" > /etc/sysctl.conf
sysctl -p
sysctl --system
systemctl disable firewalld
systemctl stop firewalld
service docker restart

IFS=',' read -r -a names <<< "${nodes_name}"
IFS=',' read -r -a ips <<< "${nodes_ip}"
cat << EOF | jq . --indent 2 > /tmp/bundle/PFMP_Installer/config/PFMP_Config.json
{"Nodes": [{"hostname": "$${names[0]}", "ipaddress": "$${ips[0]}"}, {"hostname": "$${names[1]}", "ipaddress": "$${ips[1]}"}, {"hostname": "$${names[2]}", "ipaddress": "$${ips[2]}"}], "ClusterReservedIPPoolCIDR": "10.42.0.0/23", "ServiceReservedIPPoolCIDR": "10.43.0.0/23", "RoutableIPPoolCIDR": [{"mgmt": "10.240.126.0/25"},{"oob": "10.240/127.0/25"},{"data": "10.240.128.0/25"}], "PFMPHostname": "${lb_ip}", "PMFPHostIP": "${lb_ip}"}
EOF

/tmp/bundle/PFMP_Installer/scripts/setup_installer.sh
/tmp/bundle/PFMP_Installer/scripts/install_PFMP.sh "${login_username}:${login_password}" -r azure

echo "${sshkey}" > /root/.ssh/id_rsa
chmod 400 /root/.ssh/id_rsa
username=$(ssh -o "StrictHostKeyChecking no" -i /root/.ssh/id_rsa ${login_username}@$${names[2]} kubectl get secret -n powerflex pfxm-asmui-creds -o jsonpath={.data.keycloak-username} | base64 --decode)
password=$(ssh -o "StrictHostKeyChecking no" -i /root/.ssh/id_rsa ${login_username}@$${names[2]} kubectl get secret -n powerflex pfxm-asmui-creds -o jsonpath={.data.keycloak-password} | base64 --decode)

joined_ips=$(printf ",\"%s\"" "$${ips[@]}")
echo "endpoint = \"https://${lb_ip}\"" > /root/terraform.tfvars
echo "username = \"$${username}\"" >> /root/terraform.tfvars
echo "password = \"$${password}\"" >> /root/terraform.tfvars
echo "login_credential = {" >> /root/terraform.tfvars
echo "  username = \"${login_username}\"" >> /root/terraform.tfvars
echo "  password = \"${login_password}\"" >> /root/terraform.tfvars
echo "}" >> /root/terraform.tfvars
echo "sds_ips = [$${joined_ips:1}]" >> /root/terraform.tfvars
echo "data_disk_count = ${data_disk_count}" >> /root/terraform.tfvars
echo "is_multi_az = ${is_multi_az}" >> /root/terraform.tfvars
echo "is_balanced = ${is_balanced}" >> /root/terraform.tfvars

wget https://releases.hashicorp.com/terraform/1.9.5/terraform_1.9.5_linux_amd64.zip -O /tmp/terraform_1.9.5_linux_amd64.zip
unzip /tmp/terraform_1.9.5_linux_amd64.zip -d /tmp
mv /tmp/terraform /usr/local/bin
