# /*
# Copyright (c) 2023 Dell Inc., or its subsidiaries. All Rights Reserved.

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


resource "powerflex_user" "newUser" {
  name = var.newUserName
  role = var.userRole
  password = var.userPassword
}


resource "null_resource" "provision" {
    depends_on = [powerflex_user.newUser]
    connection {     
      type     = "ssh"     
      user     = var.mdmUserName     
      password = var.mdmPassword     
      host     = var.mdmHost
      }
    provisioner "remote-exec"{         
      inline = [ "scli --login --username ${powerflex_user.newUser.name}  --password ${powerflex_user.newUser.password} ",  
      "scli --set_password --old_password ${powerflex_user.newUser.password} --new_password ${var.newPassword} "] 
    }
}