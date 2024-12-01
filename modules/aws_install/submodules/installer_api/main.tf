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

variable "hostnames" {
  type = list(string)
  description = "the list of hostnames to be used for the nodes"
}

variable "bastion_config" {
  description = "Bastion configuration"
  type = object({
    use_bastion    = bool
    bastion_host   = string
    bastion_user   = string
    bastion_ssh_key = string
  })
}

locals {
  len = length(var.co_res_ips)
  csv_name = "${local.len == 3 && var.multi_az == false ? "3_co_res.csv" :
        local.len == 5 && var.multi_az == false ? "5_co_res.csv" :
        local.len == 3 && var.multi_az == true ? "3_co_res_multi.csv" :
        local.len == 6 && var.multi_az == true ? "6_co_res.csv":
         ""}"
  deployment_type_performance = var.instance_type == "i3en.12xlarge" || var.instance_type == "i3en.metal"
}

resource null_resource "create_directory" {
  provisioner "local-exec" {
    working_dir = "${path.module}"
    interpreter = var.interpreter
    command = <<EOT
      mkdir -p ./run-installer-scripts-${var.timestamp}
      cp -r scripts/* ./run-installer-scripts-${var.timestamp}
      cp ./csv_templates/${local.csv_name} ./run-installer-scripts-${var.timestamp}/CSV_basic.csv
      dos2unix ./run-installer-scripts-${var.timestamp}/*
      chmod +x ./run-installer-scripts-${var.timestamp}/*
    EOT
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}

# Define the null_resource to execute the nvme command
resource "null_resource" "execute-getnvme-remote-script" {
  count = local.deployment_type_performance && !var.bastion_config.use_bastion ?  length(var.co_res_ips) : 0
  connection {
    type        = "ssh"
    host        = var.co_res_ips[count.index]
    user        = var.generated_username
    private_key = file(var.private_key)
  }
  provisioner "remote-exec" {
    inline = [
      "sudo nvme list -o json | jq -c '.Devices[] | select(.ModelNumber == \"Amazon EC2 NVMe Instance Storage\")' | jq '.DevicePath' | sort | sed -z 's/\\n/,/g;s/,$/\\n/' | tr -d '\"' > /tmp/nvme_disks_${var.co_res_ips[count.index]}.txt"
    ]
  }
  
  triggers = {
    always_run = "${timestamp()}"
  }
  depends_on = [null_resource.create_directory]
}
resource "null_resource" "copy-getnvme-remote-data" {
  count = local.deployment_type_performance && !var.bastion_config.use_bastion ?  length(var.co_res_ips) : 0
  provisioner "local-exec" {
    working_dir = "${path.module}"
    interpreter = var.interpreter
    command = <<EOT
      scp -o StrictHostKeyChecking=no -i ${var.private_key} ${var.generated_username}@${var.co_res_ips[count.index]}:/tmp/nvme_disks_${var.co_res_ips[count.index]}.txt ./run-installer-scripts-${var.timestamp}/.
    EOT
  }
  triggers = {
    always_run = "${timestamp()}"
  }
  depends_on = [null_resource.execute-getnvme-remote-script]
}

# Define the null_resource to execute the nvme command for bastion
resource "null_resource" "execute-getnvme-bastion-script" {
  count = local.deployment_type_performance && var.bastion_config.use_bastion ?  length(var.co_res_ips) : 0
  
  provisioner "remote-exec" {
      connection {
      type        = "ssh"
      host        = var.co_res_ips[count.index]
      user        = var.generated_username
      private_key = file(var.private_key)
      bastion_host        = var.bastion_config.use_bastion ? var.bastion_config.bastion_host : null
      bastion_user        = var.bastion_config.use_bastion ? var.bastion_config.bastion_user : null
      bastion_private_key = file(var.bastion_config.bastion_ssh_key)
    }
    inline = [
            "sudo nvme list -o json | jq -c '.Devices[] | select(.ModelNumber == \"Amazon EC2 NVMe Instance Storage\")' | jq '.DevicePath' | sort | sed -z 's/\\n/,/g;s/,$/\\n/' | tr -d '\"' > /tmp/nvme_disks_${var.co_res_ips[count.index]}.txt"
    ]
  }
 
  triggers = {
    always_run = "${timestamp()}"
  }
  depends_on = [null_resource.create_directory]
}

resource "null_resource" "copy-getnvme-bastion-data" {
  count = local.deployment_type_performance && var.bastion_config.use_bastion ?  length(var.co_res_ips) : 0
  
  provisioner "local-exec" {
    interpreter = var.interpreter
    working_dir = "${path.module}"
    command = <<EOT
      scp -o StrictHostKeyChecking=no -o ProxyCommand="ssh -i ${var.bastion_config.bastion_ssh_key}  ${var.bastion_config.bastion_user}@${var.bastion_config.bastion_host} nc %h %p"   -i ${var.private_key} ${var.generated_username}@${var.co_res_ips[count.index]}:/tmp/nvme_disks_${var.co_res_ips[count.index]}.txt ./run-installer-scripts-${var.timestamp}/.
    EOT
  }

  triggers = {
    always_run = "${timestamp()}"
  }
  depends_on = [null_resource.execute-getnvme-bastion-script]
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
      cd ./run-installer-scripts-${var.timestamp}
      if [[ ${var.instance_type} == *i3en.metal* ]] || [[ ${var.instance_type} == *i3en.12xlarge* ]];
      then
        echo "co-res is performance type"
        ./convert_ip_nvme_csv.sh ${join(" ",var.co_res_ips)}
      else
        echo "co-res is balanced type"
        ./convert_disk_mapping.sh ${join(",",var.device_mapping)}
        ./convert_csv_to_ips.sh ${join(" ",var.co_res_ips)}
      fi
      
      ./create_rest_config_json.sh ${var.installer_ip} ${join(" ",var.management_ips)} ${var.loadbalancer_ip} ${join(" ",var.hostnames)}
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
  depends_on = [null_resource.copy-getnvme-bastion-data,null_resource.copy-getnvme-remote-data]
}

output "output_directory" {
  description = "The location of the output directory"
  value       =  "${path.module}/run-installer-scripts-${var.timestamp}"
}
