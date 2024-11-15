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

# Set the ntp for installer node
resource terraform_data set_ntp {
   connection {
    type = "ssh"
    host = var.installer_node_ip
    user = var.username
    password = var.password
  }
  input = {
    ntp_ip = var.ntp_ip
  }
  provisioner "remote-exec" {
    inline = [
        "sudo sh -c 'echo server ${self.input.ntp_ip} iburst >> /etc/chrony.conf'",
        "sudo systemctl start chronyd",
        "sudo systemctl enable chronyd",
        "sudo systemctl restart chronyd",
        # Give a few moments for chryonyd to start
        "sleep 5",
        # Check to see if the ntp has a valid Reference ID that is not equal to 00000000
        # If it is then the NTP is invalid and should show error
        "chronyc tracking | if grep -q 'Reference ID    : 00000000'; then echo 'Invalid NTP IP'; exit 1; fi"
    ]
  }
}

# Set the ntp for node 1
resource terraform_data set_ntp_node1 {
   connection {
    type = "ssh"
    host = var.node_1_ip
    user = var.username
    password = var.password
  }
  input = {
    ntp_ip = var.ntp_ip
  }
  provisioner "remote-exec" {
    inline = [
        "sudo sh -c 'echo server ${self.input.ntp_ip} iburst >> /etc/chrony.conf'",
        "sudo systemctl start chronyd",
        "sudo systemctl enable chronyd",
        "sudo systemctl restart chronyd",
        # Give a few moments for chryonyd to start
        "sleep 5",
        # Check to see if the ntp has a valid Reference ID that is not equal to 00000000
        # If it is then the NTP is invalid and should show error
        "chronyc tracking | if grep -q 'Reference ID    : 00000000'; then echo 'Invalid NTP IP'; exit 1; fi"
    ]
  }
}

# Set the ntp for node 2
resource terraform_data set_ntp_node2 {
   connection {
    type = "ssh"
    host = var.node_2_ip
    user = var.username
    password = var.password
  }
  input = {
    ntp_ip = var.ntp_ip
  }
  provisioner "remote-exec" {
    inline = [
        "sudo sh -c 'echo server ${self.input.ntp_ip} iburst >> /etc/chrony.conf'",
        "sudo systemctl start chronyd",
        "sudo systemctl enable chronyd",
        "sudo systemctl restart chronyd",
        # Give a few moments for chryonyd to start
        "sleep 5",
        # Check to see if the ntp has a valid Reference ID that is not equal to 00000000
        # If it is then the NTP is invalid and should show error
        "chronyc tracking | if grep -q 'Reference ID    : 00000000'; then echo 'Invalid NTP IP'; exit 1; fi"
    ]
  }
}

# Set the ntp for node 3
resource terraform_data set_ntp_node3 {
   connection {
    type = "ssh"
    host = var.node_3_ip
    user = var.username
    password = var.password
  }
  input = {
    ntp_ip = var.ntp_ip
  }
  provisioner "remote-exec" {
    inline = [
        "sudo sh -c 'echo server ${self.input.ntp_ip} iburst >> /etc/chrony.conf'",
        "sudo systemctl start chronyd",
        "sudo systemctl enable chronyd",
        "sudo systemctl restart chronyd",
        # Give a few moments for chryonyd to start
        "sleep 5",
        # Check to see if the ntp has a valid Reference ID that is not equal to 00000000
        # If it is then the NTP is invalid and should show error
        "chronyc tracking | if grep -q 'Reference ID    : 00000000'; then echo 'Invalid NTP IP'; exit 1; fi"
    ]
  }
}

# Copy the PFMP config to the installer vm
resource "null_resource" "copy_pfmp_config" {

  connection {
    type = "ssh"
    host = var.installer_node_ip
    user = var.username
    password = var.password
    agent = false
  }

  # Copy file over to installer VM
  provisioner "file" {
    source = var.local_path_to_pfmp_config
    destination = "PFMP_Config.json"
  }

  # Move the file to the correct location (2 steps because the second one needs sudo)
  provisioner "remote-exec" {
    inline = [
        "sudo cp PFMP_Config.json /opt/dell/pfmp/PFMP_Installer/config/PFMP_Config.json",
    ]
  }
}

locals {
  // If use_co_res is true the first statement is taken with the `-r` flag else it will be non-co-res
  pfmp_install_cmd = var.use_co_res ? "sudo ./install_PFMP.sh -r ${var.username}:${var.password}" : "sudo ./install_PFMP.sh ${var.username}:${var.password}"
}

# Installer node, and run install script
resource terraform_data install_pfmp {
  input = {
    username = var.username
    password = var.password
    installer_node_ip = var.installer_node_ip
    pfmp_install_cmd_output = local.pfmp_install_cmd
  }

  connection {
    type = "ssh"
    host = self.output.installer_node_ip
    user = self.output.username
    password = self.output.password
  }

  provisioner "remote-exec" {
    inline = [
        "cd /opt/dell/pfmp/PFMP_Installer/scripts",
        "sudo ./setup_installer.sh",
        "${local.pfmp_install_cmd}",
    ]
  }
  // Run this step last
  depends_on = [ 
    null_resource.copy_pfmp_config,
    terraform_data.set_ntp,
    terraform_data.set_ntp_node1,
    terraform_data.set_ntp_node2,
    terraform_data.set_ntp_node3
  ]
}
