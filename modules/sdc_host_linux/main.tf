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
# # 2. downaload of scini
# # 3. verification of kernel version.
# # 4. SDC installation on Linux

# # needed for ubuntu for installing kernel-specific scini module
locals {
  pflex_v = var.versions.pflex
  kernel_v = var.versions.kernel
}

# # STEP 1 - download SDC artifacts from share to local machine


locals {
  use_remote_path = var.sdc_pkg.use_remote_path
  share_url_scini = var.scini.url
}
resource terraform_data sdc_pkg_local {
  #do if use_remote_path is false.
  count = ( var.sdc_pkg.use_remote_path && !var.sdc_pkg.skip_download_sdc) ? 0: 1
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

# # STEP 2 - load remote login secrets
# # ssh private key of SDC login user
data local_sensitive_file ssh_key {
   count = var.remote_host.private_key == "" ? 0 : 1
   filename = var.remote_host.private_key
}

# # ssh certificate issued to SDC login user
data local_sensitive_file ssh_cert {
  count = var.remote_host.certificate == "" ? 0 : 1
  filename = var.remote_host.certificate
}

#compare kernel version on remote machine with provided version
resource "terraform_data" "compare_version" {

   connection {
    type = "ssh"
    user = self.output.user.name
    private_key = self.output.user.private_key
    certificate = self.output.user.certificate
    host = self.output.ip
    password = self.output.user.password
  }
  input = {
      user = {
          name = var.remote_host.user
          #user can use keys or userid/password. Make sure to copy the keys to remote server before using keys
          private_key = var.remote_host.private_key == "" ? "" : data.local_sensitive_file.ssh_key[0].content
          certificate = var.remote_host.certificate == "" ? "" : data.local_sensitive_file.ssh_cert[0].content
          password = var.remote_host.password
      }
      sdc_pkg = var.sdc_pkg
      kernel_v = local.kernel_v
      ip  = var.ip
  }

  provisioner "remote-exec" {
    inline = [
      "cd ${self.output.sdc_pkg.remote_dir}",
      "echo '#!/bin/bash' > compare_kernel.sh",
      "echo 'current_version=$(uname -r)' >> compare_kernel.sh",
      "echo 'compare_version=\"${self.output.kernel_v}\"' >> compare_kernel.sh",
      "echo 'if [ \"$current_version\" != \"$compare_version\" ]; then' >> compare_kernel.sh",
      "echo '  echo \"Kernel version $current_version does not match with specified $compare_version. Aborting...\"' >> compare_kernel.sh",
      "echo '  exit 1' >> compare_kernel.sh",
      "echo 'fi' >> compare_kernel.sh",
      "chmod +x compare_kernel.sh",
      "./compare_kernel.sh"
     ]
  }
   provisioner "remote-exec" {
    when = destroy
    inline = [
      "rm  ${self.output.sdc_pkg.remote_dir}/compare_kernel.sh"
    ]
  }

}


#copy SDC package on remote server
resource terraform_data sdc_pkg_remote {
  # perform if variable is true
  count = ( local.use_remote_path && !var.sdc_pkg.skip_download_sdc) ? 1: 0
  connection {
    type = "ssh"
    user = self.output.user.name
    private_key = self.output.user.private_key
    certificate = self.output.user.certificate
    host = self.output.ip
    password = self.output.user.password
  }
  input = {
      user = {
          name = var.remote_host.user
          #user can use keys or userid/password. Make sure to copy the keys to remote server before using keys
          private_key = var.remote_host.private_key == "" ? "" : data.local_sensitive_file.ssh_key[0].content
          certificate = var.remote_host.certificate == "" ? "" : data.local_sensitive_file.ssh_cert[0].content
          password = var.remote_host.password
      }
      sdc_pkg = var.sdc_pkg
      ip = var.ip
  }

  provisioner "remote-exec" {
    inline = [
      "wget ${self.output.sdc_pkg.url} -O ${self.output.sdc_pkg.remote_dir}/${self.output.sdc_pkg.remote_pkg_name}",
    ]
  }
  provisioner "remote-exec" {
    when = destroy
    inline = [
      "rm -rf ${self.output.sdc_pkg.remote_dir}/${self.output.sdc_pkg.remote_pkg_name}"
    ]
  }

}




# # STEP 3 - install pre-requisites (scini module)
# # provisioner to install scini module on SDC
resource "terraform_data" "linux_scini" {
  count = ( var.scini.linux_distro == "RHEL" || var.scini.autobuild_scini) ? 0 : 1
  connection {
    type = "ssh"
    user = self.output.user.name
    private_key = self.output.user.private_key
    certificate = self.output.user.certificate
    host = self.output.ip
    password = self.output.user.password
  }
  input = {
      versions = {
          pflex = local.pflex_v
          kernel = local.kernel_v
      }
      user = {
          name = var.remote_host.user
          #user can use keys or userid/password. Make sure to copy the keys to remote server before using keys
          private_key = var.remote_host.private_key == "" ? "" : data.local_sensitive_file.ssh_key[0].content
          certificate = var.remote_host.certificate == "" ? "" : data.local_sensitive_file.ssh_cert[0].content
          password = var.remote_host.password
      }
      ip = var.ip
      scini_url = var.scini.url
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /bin/emc/scaleio/scini_sync/driver_cache/Ubuntu/${local.pflex_v}/${local.kernel_v}",
      "wget ${self.output.scini_url}/scini.ko -P /bin/emc/scaleio/scini_sync/driver_cache/Ubuntu/${local.pflex_v}/${local.kernel_v}",
    ]
  }
  provisioner "remote-exec" {
    when = destroy
    inline = [
      "rm -rf /bin/emc/scaleio/scini_sync/driver_cache/Ubuntu"
    ]
  }
}

# # provisioner to install scini module on SDC
resource "terraform_data" "linux_scini_auto" {
  # Execute when autobuild flag is set and if it is not RHEL
  count = ( var.scini.linux_distro != "RHEL" && var.scini.autobuild_scini) ? 1 : 0
  connection {
    type = "ssh"
    user = self.output.user.name
    private_key = self.output.user.private_key
    certificate = self.output.user.certificate
    host = self.output.ip
    password = self.output.user.password
  }
  input = {
      user = {
          name = var.remote_host.user
          #user can use keys or userid/password. Make sure to copy the keys to remote server before using keys
          private_key = var.remote_host.private_key == "" ? "" : data.local_sensitive_file.ssh_key[0].content
          certificate = var.remote_host.certificate == "" ? "" : data.local_sensitive_file.ssh_cert[0].content
          password = var.remote_host.password
      }
      ip = var.ip
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /etc/emc/scaleio/scini_sync",
      "touch /etc/emc/scaleio/scini_sync/.build_scini",
    ]
  }
  provisioner "remote-exec" {
    when = destroy
    inline = [
      "rm /etc/emc/scaleio/scini_sync/.build_scini"
    ]
  }
}


# # STEP 4 - Install actual SDC
# # SDC configuration
 resource powerflex_sdc_host sdc_local_path {

   count = local.use_remote_path ? 0 : 1 #deploy if variable is false
   depends_on = [ terraform_data.compare_version,
                  terraform_data.linux_scini]
   ip = var.ip
   remote = {
     user = var.remote_host.user
     private_key = var.remote_host.private_key == "" ? null : data.local_sensitive_file.ssh_key[0].content
     certificate = var.remote_host.certificate == "" ? null : data.local_sensitive_file.ssh_cert[0].content
     password =  var.remote_host.password == "" ? null : var.remote_host.password
     dir = terraform_data.sdc_pkg_local[0].output.remote_dir
   }
   os_family = "linux"
   use_remote_path = local.use_remote_path
   name = "sdc-${var.ip}"
   package_path = "${terraform_data.sdc_pkg_local[0].output.local_dir}/${terraform_data.sdc_pkg_local[0].output.pkg_name}"
   clusters_mdm_ips = var.mdm_ips
 }

 resource powerflex_sdc_host sdc_remote_path {
   count = local.use_remote_path  ? 1 : 0 #deploy if variable is true
   depends_on = [ terraform_data.compare_version,
                  terraform_data.linux_scini]
   ip = var.ip
   remote = {
     user = var.remote_host.user
     private_key = var.remote_host.private_key == "" ? null : data.local_sensitive_file.ssh_key[0].content
     certificate = var.remote_host.certificate == "" ? null : data.local_sensitive_file.ssh_cert[0].content
     password =  var.remote_host.password == "" ? null : var.remote_host.password
     dir = terraform_data.sdc_pkg_remote[0].output.sdc_pkg.remote_dir
   }
   os_family = "linux"
   use_remote_path = local.use_remote_path
   name = "sdc-${var.ip}"
   package_path = terraform_data.sdc_pkg_remote[0].output.sdc_pkg.pkg_name
   clusters_mdm_ips = var.mdm_ips
 }

