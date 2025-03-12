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


# # Objectives
# # 1. Copy of sdc package on either local or remote machine
# # 2. SDC installation on Windows

locals {
  use_remote_path = var.sdc_pkg.use_remote_path
}

resource terraform_data sdc_pkg_local {
  #do if use_remote_path is false.
  count = var.sdc_pkg.use_remote_path ? 0: 1
  input = var.sdc_pkg
  #One option is to download sdc on local drive and provide local path
  provisioner "local-exec" {
    command = "wget ${self.output.url} -P ${self.output.local_dir}"
  }
  provisioner "local-exec" {
    when = destroy
    command = "rm -r ${self.output.local_dir}/${self.output.pkg_name}"
  }
}

#copy SDC package on remote server
resource terraform_data sdc_pkg_remote {
  # perform if variable is true
  count = local.use_remote_path ? 1 : 0
  connection {
      type     = "winrm"
      user     = self.output.user.name
      password = self.output.user.password
      host     = self.output.ip
    }

  input = {
      user = {
          name = var.remote_host.user
          password = var.remote_host.password
      }
      sdc_pkg = var.sdc_pkg
      ip = var.ip
  }
  provisioner "remote-exec" {
    inline = [
      "powershell -Command \"Invoke-WebRequest -Uri '${self.output.sdc_pkg.url}' -OutFile 'C:\\EMC-ScaleIO-sdc.msi'\""
    ]
  }
  provisioner "remote-exec" {
    when    = destroy
    inline = [
      "powershell -Command \"Remove-Item -Path 'C:\\EMC-ScaleIO-sdc.msi'\""
    ]
  }
}

# # STEP 2 - Install actual SDC
# # SDC configuration


# generate a random guid. This is required only for windows hosts.
resource "random_uuid" "sdc_guid" {
}

resource powerflex_sdc_host sdc_local_path {

   count = local.use_remote_path ? 0 : 1 #deploy if variable is false
   ip = var.ip
   remote = {
     user = var.remote_host.user
     password =  var.remote_host.password
     port = 5985
   }
   os_family = "windows"
   use_remote_path = local.use_remote_path
   name = var.sdc_name
   package_path = "${terraform_data.sdc_pkg_local[0].output.local_dir}/${terraform_data.sdc_pkg_local[0].output.pkg_name}"
   clusters_mdm_ips = var.mdm_ips
 }

 resource powerflex_sdc_host sdc_remote_path {
   count = local.use_remote_path  ? 1 : 0 #deploy if variable is true
   ip = var.ip
   remote = {
     user = var.remote_host.user
     password =  var.remote_host.password 
     port = 5985
   }
   os_family = "windows"
   use_remote_path = local.use_remote_path
   name = var.sdc_name
   package_path = terraform_data.sdc_pkg_remote[0].output.sdc_pkg.pkg_name
   clusters_mdm_ips = var.mdm_ips
 }
