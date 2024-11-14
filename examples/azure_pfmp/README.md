<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azure_pfmp"></a> [azure\_pfmp](#module\_azure\_pfmp) | ../../modules/azure_pfmp | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix for Azure resource names | `string` | n/a | yes |
| <a name="input_existing_resource_group"></a> [existing\_resource\_group](#input\_existing\_resource\_group) | Name of existing resource group to use. If not set, a new resource group will be created | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Location for Azure resources, default to `eastus` | `string` | `"eastus"` | no |
| <a name="input_enable_bastion"></a> [enable\_bastion](#input\_enable\_bastion) | Enable bastion, default to `false` | `bool` | `false` | no |
| <a name="input_enable_jumphost"></a> [enable\_jumphost](#input\_enable\_jumphost) | Enable jumphost, default to `false` | `bool` | `false` | no |
| <a name="input_enable_sql_workload_vm"></a> [enable\_sql\_workload\_vm](#input\_enable\_sql\_workload\_vm) | Enable sql workload vm, default to `false` | `bool` | `false` | no |
| <a name="input_cluster_node_count"></a> [cluster\_node\_count](#input\_cluster\_node\_count) | PowerFlex cluster node number, default to `5` | `number` | `5` | no |
| <a name="input_is_multi_az"></a> [is\_multi\_az](#input\_is\_multi\_az) | Whether to deploy the PowerFlex cluster in single or multiple availability zones, default is `false` | `bool` | `false` | no |
| <a name="input_deployment_type"></a> [deployment\_type](#input\_deployment\_type) | PowerFlex cluster deployment type, Possible values are: 'balanced', 'optimized_v1' or 'optimized_v2'. Default is `balanced` | `string` | `"balanced"` | no |
| <a name="input_data_disk_count"></a> [data\_disk\_count](#input\_data\_disk\_count) | The number of data disks attached to each PowerFlex cluster node, default is `20` | `number` | `20` | no |
| <a name="input_data_disk_size_gb"></a> [data\_disk\_size\_gb](#input\_data\_disk\_size\_gb) | The size of each data disk in GB, default is `512` | `number` | `512` | no |
| <a name="input_data_disk_logical_sector_size"></a> [data\_disk\_logical\_sector\_size](#input\_data\_disk\_logical\_sector\_size) | Logical Sector Size. Possible values are: 512 and 4096. Default is `512` | `number` | `512` | no |
| <a name="input_login_credential"></a> [login\_credential](#input\_login\_credential) | Login credential for Azure VMs | <pre>object({<br>  username = string<br>  password = string<br>})</pre> | <pre>{<br>  username = "pflexuser"<br>  password = "PowerFlex123!"<br>}</pre> | no |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | SSH key pair for Azure VMs | <pre>object({<br>  public = string<br>  private = string<br>})</pre> | <pre>{<br>  public = "./ssh/azure.pem.pub"<br>  private = "./ssh/azure.pem"<br>}</pre> | no |
| <a name="input_storage_instance_gallary_image"></a> [storage\_instance\_gallary\_image](#input\_storage\_instance\_gallary\_image) | PowerFlex storage instance image in local gallary. If set, the storage instance vm will be created from this image | <pre>object({<br>  name = string<br>  image_name = string<br>  gallery_name = string<br>  resource_group_name = string<br>})</pre> | `null` | no |
| <a name="input_installer_gallary_image"></a> [installer\_gallary\_image](#input\_installer\_gallary\_image) |PowerFlex installer image in local gallary. If set, the installer vm will be created from this image | <pre>object({<br>  name = string<br>  image_name = string<br>  gallery_name = string<br>  resource_group_name = string<br>})</pre> | `null` | no |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | Virtual network address space, default to `10.2.0.0/16` | `string` | `"10.2.0.0/16"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnets for the virtual network | <pre>list(object({<br>  name = string<br>  prefix = string<br>}))</pre> | <pre>[{<br>  name = "BlockStorageSubnet"<br>  prefix = "10.2.0.0/24"<br>}]</pre> | no |
| <a name="input_bastion_subnet"></a> [bastion\_subnet](#input\_bastion\_subnet) | Bastion subnet info | <pre>object({<br>  name = string<br>  prefix = string<br>})</pre> | <pre>{<br>  name = "AzureBastionSubnet"<br>  prefix = "10.2.1.0/26"<br>}</pre> | no |
| <a name="input_pfmp_lb_ip"></a> [pfmp\_lb\_ip](#input\_pfmp\_lb\_ip) | Load balancer IP for PFMP service | `string` | `"10.2.0.200"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_tunnel"></a> [bastion\_tunnel](#output\_bastion\_tunnel) | n/a |
| <a name="output_sds_nodes"></a> [sds\_nodes](#output\_sds\_nodes) | n/a |
| <a name="output_pfmp_ip"></a> [pfmp\_ip](#output\_pfmp\_ip) | n/a |
<!-- END_TF_DOCS -->
