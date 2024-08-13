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
  description = "Stores the IP address of the remote Windows host."
}

variable "remote_host" {
  description = "Stores the credentials for connecting to the remote Windows host."
  type        = object({
    # Define the `user` attribute of the `remote` variable.
    user = string
    password = string
  })

}

variable "powerflex_config" {
  description = "Stores the configuration for terraform PowerFlex provider."
  type        = object({
    # Define the attributes of the configuration for terraform PowerFlex provider.
    username = string
    endpoint = string
    password = string
  })
}

variable "mdm_ips" {
  description = "all the mdms (either primary,secondary or virtual ips) in a comma separated list by cluster if unset will use the mdms of the cluster set in the provider block eg. ['10.10.10.5,10.10.10.6', '10.10.10.7,10.10.10.8']"
  type        = list(string)
  default = []
}

variable "sdc_pkg" {
  description = "configuration for SDC package like url to download package from, copy as local package or at directory on remote server."
  type = object({
    # examples "http://example.com/EMC-ScaleIO-sdc-3.6-700.103.msi", "ftp://username:password@ftpserver/path/to/file"
    url = string
    # the name of the SDC package saved in local directory.
    pkg_name = string
    # the local directory where the SDC package will be downloaded.
    local_dir = string
    # download and use the SDC package on remote machine path (where SDC is going to be deployed)
    use_remote_path = bool
  })
}