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
for var in "${@}"
do
  echo -e "sudo ssh -i /var/pfmp/keys/id_rsa -o 'StrictHostKeyChecking no' pflex-user@$var 'bash -s' < ./remove-rpm.sh" >> ./clean-core.sh
done
echo -e "sudo ssh -i /var/pfmp/keys/id_rsa -o 'StrictHostKeyChecking no' pflex-user@$1 'bash -s' < ./reset-pods.sh" >> ./clean-core.sh