<!--
Copyright (c) 2024 Dell Inc., or its subsidiaries. All Rights Reserved.

Licensed under the Mozilla Public License Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://mozilla.org/MPL/2.0/


Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | ~>1.5 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.pflex_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.pflex_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_virtual_network.pflex_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_subnet.pflex_subnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_network_security_group.pflex_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_subnet_network_security_group_association.pflex_nsg_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet.pflex_bastion_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_public_ip.bastion_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_bastion_host.bastion_host](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/bastion_host) | resource |
| [azurerm_network_interface.jumphost_nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_windows_virtual_machine.jumphost_vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |
| [azurerm_network_interface.sqlvm_nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_windows_virtual_machine.sqlvm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |
| [azurerm_mssql_virtual_machine.sqlvm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_virtual_machine) | resource |
| [azurerm_shared_image_version.storage_instance_ami](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/shared_image_version) | data source |
| [azurerm_shared_image_version.installer_ami](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/shared_image_version) | data source |
| [azurerm_network_interface.storage_instance_nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_linux_virtual_machine.storage_instance](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_managed_disk.data_disks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_virtual_machine_data_disk_attachment.vm_data_disk_attachment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_network_interface.installer_nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_linux_virtual_machine.installer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_virtual_machine_run_command.wait_pfmp_installation1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_run_command) | resource |
| [azurerm_virtual_machine_run_command.wait_pfmp_installation2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_run_command) | resource |
| [azurerm_lb.load_balancer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb) | resource |
| [azurerm_lb_probe.pfmp_probe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe) | resource |
| [azurerm_lb_backend_address_pool.lb_be_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool) | resource |
| [azurerm_lb_rule.lb-rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) | resource |
| [azurerm_network_interface_backend_address_pool_association.lb_be_pool_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix for Azure resource names | `string` | n/a | yes |
| <a name="input_existing_resource_group"></a> [existing\_resource\_group](#input\_existing\_resource\_group) | Name of existing resource group to use. If not set, a new resource group will be created | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Location for Azure resources, default to `eastus` | `string` | `"eastus"` | no |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | Virtual network address space, default to `10.2.0.0/16` | `string` | `"10.2.0.0/16"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnets for the virtual network | <pre>list(object({<br>  name = string<br>  prefix = string<br>}))</pre> | <pre>[{<br>  name = "BlockStorageSubnet"<br>  prefix = "10.2.0.0/24"<br>}]</pre> | no |
| <a name="input_enable_bastion"></a> [enable\_bastion](#input\_enable\_bastion) | Enable bastion, default to `false` | `bool` | `false` | no |
| <a name="input_bastion_subnet"></a> [bastion\_subnet](#input\_bastion\_subnet) | Bastion subnet info | <pre>object({<br>  name = string<br>  prefix = string<br>})</pre> | <pre>{<br>  name = "AzureBastionSubnet"<br>  prefix = "10.2.1.0/26"<br>}</pre> | no |
| <a name="input_enable_jumphost"></a> [enable\_jumphost](#input\_enable\_jumphost) | Enable jumphost, default to `false` | `bool` | `false` | no |
| <a name="input_enable_sql_workload_vm"></a> [enable\_sql\_workload\_vm](#input\_enable\_sql\_workload\_vm) | Enable sql workload vm, default to `false` | `bool` | `false` | no |
| <a name="input_cluster"></a> [cluster](#input\_cluster) | PowerFlex cluster configuration, including: node number, deploy in single or multiple availability zones, deployment type can be 'balanced', 'optimized_v1' or 'optimized_v2', the number of data disks attached to a single node and the size of each | <pre>object({<br>  node_count = number<br>  is_multi_az = bool<br>  deployment_type = string<br>  data_disk_count = number<br>  data_disk_size_gb = number<br>})</pre> | <pre>{<br>  node_count = 5<br>  is_multi_az = false<br>  deployment_type = "balanced"<br>  data_disk_count = 20<br>  data_disk_size_gb = 512<br>}</pre> | no |
| <a name="input_enable_accelerated_networking"></a> [enable\_accelerated\_networking](#input\_enable\_accelerated\_networking) | Enable accelerated networking for the cluster, default to `true` | `bool` | `true` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Azure availability zones, default to `["1", "2", "3"]` | `list(string)` | `["1", "2", "3"]` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | Azure VM size. | <pre>object({<br>  jumphost = string<br>  installer = string<br>  sqlvm = string<br>  balanced = string<br>  optimized_v1 = string<br>  optimized_v2 = string<br>})</pre> | <pre>{<br>  jumphost = "Standard_D2s_v3"<br>  installer = "Standard_D4s_v3"<br>  sqlvm = "Standard_D4ds_v5"<br>  balanced = "Standard_F48s_v2"<br>  optimized_v1 = "Standard_L32as_v3"<br>  optimized_v2 = "Standard_L64as_v3"<br>}</pre> | no |
| <a name="input_os_disk_size_gb"></a> [os\_disk\_size\_gb](#input\_os\_disk\_size\_gb) | Azure VM OS disk size in GB, default to `512` | `number` | `512` | no |
| <a name="input_image_reference"></a> [image\_reference](#input\_image\_reference) | PowerFlex VM default image in Azure marketplace. Values from https://azuremarketplace.microsoft.com/en-us/marketplace/apps/dellemc.dell_apex_block_storage | <pre>object({<br>  publisher = string<br>  offer = string<br>  storage460 = string<br>  storage450 = string<br>  installer460 = string<br>  installer450 = string<br>})</pre> | <pre>{<br>  publisher = "dellemc"<br>  offer = "dell_apex_block_storage"<br>  storage460 = "apexblockstorage-4_6_0"<br>  storage450 = "apexblockstorage"<br>  installer460 = "apexblockstorageinstaller-4_6_0"<br>  installer450 = "installer45"<br>}</pre> | no |
| <a name="input_storage_instance_gallary_image"></a> [storage\_instance\_gallary\_image](#input\_storage\_instance\_gallary\_image) | PowerFlex storage instance image in local gallary. If set, the storage instance vm will be created from this image | <pre>object({<br>  name = string<br>  image_name = string<br>  gallery_name = string<br>  resource_group_name = string<br>})</pre> | `null` | no |
| <a name="input_installer_gallary_image"></a> [installer\_gallary\_image](#input\_installer\_gallary\_image) |PowerFlex installer image in local gallary. If set, the installer vm will be created from this image | <pre>object({<br>  name = string<br>  image_name = string<br>  gallery_name = string<br>  resource_group_name = string<br>})</pre> | `null` | no |
| <a name="input_jumphost_image_reference"></a> [jumphost\_image\_reference](#input\_jumphost\_image\_reference) | Jumphost image | <pre>object({<br>  publisher = string<br>  offer = string<br>  sku = string<br>  version = string<br>})</pre> | <pre>{<br>  publisher = "MicrosoftWindowsServer"<br>  offer = "WindowsServer"<br>  sku = "2022-datacenter-azure-edition"<br>  version = "latest"<br>}</pre> | no |
| <a name="input_sqlvm_image_reference"></a> [sqlvm\_image\_reference](#input\_sqlvm\_image\_reference) | Sqlvm image | <pre>object({<br>  publisher = string<br>  offer = string<br>  sku = string<br>  version = string<br>})</pre> | <pre>{<br>  publisher = "microsoftsqlserver"<br>  offer = "sql2022-ws2022"<br>  sku = "sqldev-gen2"<br>  version = "16.0.240923"<br>}</pre> | no |
| <a name="input_login_credential"></a> [login\_credential](#input\_login\_credential) | Login credential for Azure VMs | <pre>object({<br>  username = string<br>  password = string<br>})</pre> | n/a | yes |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | SSH key pair for Azure VMs | <pre>object({<br>  public = string<br>  private = string<br>})</pre> | n/a | yes |
| <a name="input_data_disk_iops_read_write"></a> [data\_disk\_iops\_read\_write](#input\_data\_disk\_iops\_read\_write) | The number of IOPS allowed for this disk. Please refer to https://www.dell.com/support/manuals/en-hk/scaleio/flex-cloud-azure-deploy-45x/create-the-virtual-machine-for-the-storage-instance?guid=guid-c87fe065-5e65-4c96-84b9-a8f5065230cd&lang=en-us | `number` | `4000` | no |
| <a name="input_data_disk_mbps_read_write"></a> [data\_disk\_mbps\_read\_write](#input\_data\_disk\_mbps\_read\_write) | The bandwidth allowed for this disk. Please refer to https://www.dell.com/support/manuals/en-hk/scaleio/flex-cloud-azure-deploy-45x/create-the-virtual-machine-for-the-storage-instance?guid=guid-c87fe065-5e65-4c96-84b9-a8f5065230cd&lang=en-us | `number` | `125` | no |
| <a name="input_data_disk_logical_sector_size"></a> [data\_disk\_logical\_sector\_size](#input\_data\_disk\_logical\_sector\_size) | Logical Sector Size. Possible values are: 512 and 4096. Please refer to https://www.dell.com/support/manuals/en-hk/scaleio/flex-cloud-azure-deploy-45x/create-the-virtual-machine-for-the-storage-instance?guid=guid-c87fe065-5e65-4c96-84b9-a8f5065230cd&lang=en-us | `number` | `512` | no |
| <a name="input_pfmp_lb_ip"></a> [pfmp\_lb\_ip](#input\_pfmp\_lb\_ip) | Load balancer IP for PFMP service | `string` | `"10.2.0.200"` | no |
| <a name="input_nsg_rules"></a> [nsg\_rules](#input\_nsg\_rules) | Network security rules. Please refer to https://www.dell.com/support/manuals/en-hk/scaleio/flex-cloud-azure-deploy-45x/network-security-rules?guid=guid-952be9de-35c0-4f1a-bd2e-36b89c756b7a&lang=en-us | <pre>list(object({<br>  name = string<br>  priority = number<br>  direction = string<br>  access = string<br>  protocol = string<br>  source_port_range = string<br>  destination_port_range = string<br>  source_address_prefix = string<br>  destination_address_prefix = string<br>}))</pre> | Please refer to the variable.tf file for the default value | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_tunnel"></a> [bastion\_tunnel](#output\_bastion\_tunnel) | n/a |
| <a name="output_pfmp_ip"></a> [pfmp\_ip](#output\_pfmp\_ip) | n/a |
| <a name="output_sds_nodes"></a> [sds\_nodes](#output\_sds\_nodes) | n/a |
<!-- END_TF_DOCS -->
