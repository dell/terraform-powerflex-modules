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


# This Terraform module installs the SDC package on a remote Linux host using the `powerflex_sdc_host` resource.

# Define the input variables for the module
variable "ip" {
  type        = string
  description = "Stores the IP address of the remote Linux host."
}

variable "sdc_name" {
  type        = string
  description = "Stores the name which we want to designate to the SDC. Defaults to terraform-sdc."
  default     = "terraform-sdc"
}

variable "remote_host" {
  description = "Stores the SSH credentials for connecting to the remote Linux host."
  type        = object({
    # Define the `user` attribute of the `remote` variable.
    user = string
    # Define the ssh `private_key` file with path for the SDC login user
    private_key = optional(string, "")
    # Define the ssh `certificate` file path, issued to the SDC login user
    certificate = optional(string, "")
    password = optional(string)
  })
}

variable "mdm_ips" {
  description = "all the mdms (either primary,secondary or virtual ips) in a comma separated list by cluster if unset will use the mdms of the cluster set in the provider block eg. ['10.10.10.5,10.10.10.6', '10.10.10.7,10.10.10.8']"
  type        = list(string)
  default = []
}

variable "scini" {
 
  description = "The SCINI module package related variables."
  type = object({
    # The URL where the SCINI module package is located. Ignored if autobuild_scini is true.
    url = optional(string)
    # specify distro where SDC will be deployed eg. RHEL9, Ubuntu etc. as case sensitive
    linux_distro = string
    #allow to build scini on destination machine. This may not work on PowerFlex v3.X. Prerequisites here https://www.dell.com/support/kbdoc/en-us/000224134/how-to-on-demand-compilation-of-the-powerflex-sdc-driver 
    autobuild_scini = optional(bool, false)
  })
}

variable "sdc_pkg" {
  description = "configuration for SDC package like url to download package from, copy as local package or directory on remote server. One of local_dir or remote_dir will be used based on the variable use_remote_path"
  type = object({
    # examples "http://example.com/EMC-ScaleIO-sdc-3.6-700.103.Ubuntu.22.04.x86_64.tar", "ftp://username:password@ftpserver/path/to/file"
    url = optional(string)
    #the name of the SDC package for local.
    pkg_name = optional(string)
    #the name of the SDC package for remote machine. It should be emc-sdc-package.(tar/rpm)
    remote_pkg_name = optional(string)
    #local directory where the SDC package will be downloaded.
    local_dir = optional(string)
    #remote directory where the SDC package will be downloaded. (if use_remote_path is true)
    remote_dir = optional(string, "/tmp")
    # use the SDC package on remote machine path (where SDC is deployed)
    use_remote_path = bool
    # if SDC package is available in local directory, download can be skipped by setting to true
    skip_download_sdc = optional(bool, false)
  })
}

variable "versions" {
  type = object({
    pflex = string
    kernel = string
  })
}
