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

variable "co_res_ips" {
  type = list(string)
  description = "the list of co-res private ips"
}
variable "management_ips" {
  type = list(string)
  description = "the list of mno private ips"
}
variable "installer_ip" {
  type = string
  description = "the installer private ip"
}

variable "loadbalancer_dns" {
  type = string
  description = "the load balancer dns domain name"
}

variable "loadbalancer_ip" {
  type = string
  description = "the load balancer IP"
}

variable "interpreter" {
  type = list(string)
  description = "the interpreter of this script"
}
variable "device_mapping" {
  type = list(string)
  description = "the disk device mapping"
}
variable "private_key" {
  type = string
  description = "the private key location path"
}
variable "generated_username" {
  type = string
  description = "login user name for the node"
}
variable "instance_type" {
  type = string
  description = "the co-res instance type"
}
variable "timestamp" {
  type = string
  description = "current timestamp of the deployment script"
}

variable "multi_az" {
  description = "Enable multi-AZ deployment"
  type        = bool
}


locals {
  len = length(var.co_res_ips)
  csv_name = "${local.len == 3 && var.multi_az == false ? "3_co_res.csv" :
        local.len == 5 && var.multi_az == false ? "5_co_res.csv" :
        local.len == 3 && var.multi_az == true ? "3_co_res_multi.csv" :
        local.len == 6 && var.multi_az == true ? "6_co_res.csv":
         ""}"
}


resource "null_resource" "run_new_installer_api" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    working_dir = "${path.module}"
    interpreter = var.interpreter
    command = <<-EOT
      export LANG=C.UTF-8
      mkdir ./run-installer-scripts-${var.timestamp}
      cp -r ./scripts/* ./run-installer-scripts-${var.timestamp}
      cp ./csv_templates/${local.csv_name} ./run-installer-scripts-${var.timestamp}/CSV_basic.csv
      dos2unix ./run-installer-scripts-${var.timestamp}/*
      chmod +x ./run-installer-scripts-${var.timestamp}/*
      cd ./run-installer-scripts-${var.timestamp}
      if [[ ${var.instance_type} == *i3en.metal* ]];
      then
        echo "co-res is bare metal type"
        ./update_nvme_disk_mapping.sh ${var.private_key} ${var.generated_username} ${join(" ",var.co_res_ips)}
      else
        echo "co-res is virtual type"
        ./convert_disk_mapping.sh ${join(",",var.device_mapping)}
      fi
      ./convert_csv_to_ips.sh ${join(" ",var.co_res_ips)}
      ./create_rest_config_json.sh ${var.installer_ip} ${join(" ",var.management_ips)} ${var.loadbalancer_ip}
      cd ../ && rm -rf ./run-installer-scripts-${var.timestamp}/update_nvme_disk_mapping.sh ./run-installer-scripts-${var.timestamp}/get_nvme_disks.sh ./run-installer-scripts-${var.timestamp}/convert_disk_mapping.sh ./run-installer-scripts-${var.timestamp}/convert_csv_to_ips.sh ./run-installer-scripts-${var.timestamp}/create_rest_config_json.sh ./run-installer-scripts-${var.timestamp}/CSV_basic.csv ./run-installer-scripts-${var.timestamp}/PF_Installer_template.json ./run-installer-scripts-${var.timestamp}/core_deployment.csv

       # print all the system data (installer ip, loadbalancer ip/dns, nodes ips)  to system.out file
       system_output="./run-installer-scripts-${var.timestamp}/system.out"
         (
           echo "--------------"
           echo "installer:"
           echo ${var.installer_ip}
           echo "--------------"
           echo "loadbalancer:"
           echo -ne "DNS : \t"
           echo ${var.loadbalancer_dns}
           echo -ne "IP  : \t"
           echo ${var.loadbalancer_ip}
           #echo $(ping -n 1 ${var.loadbalancer_dns} | grep Pinging | cut -d"[" -f2 | cut -d "]" -f1)
           echo "--------------"
           echo "Nodes ips:"
           echo "${join("\n",var.co_res_ips)}"
           echo "--------------"
        ) >> $system_output


    EOT
  }
}
output "output_directory" {
  description = "The location of the output directory"
  value       =  "${path.module}/run-installer-scripts-${var.timestamp}"
}
