<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="requirement_powerflex"></a> [powerflex](#requirement\_powerflex) | >=1.6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [powerflex_package.packages](https://registry.terraform.io/providers/dell/powerflex/latest/docs/resources/package) | resource |
| [powerflex_cluster.pflex_cluster](https://registry.terraform.io/providers/dell/powerflex/latest/docs/resources/cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_username"></a> [username](#input\_username) | PowerFlex manamgement platform username | `string` | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | PowerFlex manamgement platform password | `string` | n/a | yes |
| <a name="input_endpoint"></a> [endpoint](#input\_endpoint) | PowerFlex manamgement platform endpoint | `string` | n/a | yes |
| <a name="input_insecure"></a> [insecure](#input\_insecure) | Specifies if the user wants to skip SSL verification | `bool` | `true` | no |
| <a name="input_login_credential"></a> [login\_credential](#input\_login\_credential) | SSH login credential for the PowerFlex cluster nodes. | <pre>object({<br>  username = string<br>  password = string<br>})</pre> | n/a | yes |
| <a name="input_packages"></a> [packages](#input\_packages) | The list of path of packages | `list(string)` | Please refer to the variable.tf file for the default value | no |
| <a name="input_sds_ips"></a> [sds\_ips](#input\_sds\_ips) | PowerFlex cluster nodes IP list | `list(string)` | n/a | yes |
| <a name="input_protection_domain"></a> [protection\_domain](#input\_protection\_domain) | Protection domain name, default to `PD1` | `string` | `"PD1"` | no |
| <a name="input_storage_pool"></a> [storage\_pool](#input\_storage\_pool) | Storage pool name, default to `SP1` | `string` | `"SP1"` | no |
| <a name="input_data_disk_count"></a> [data\_disk\_count](#input\_data\_disk\_count) | The number of data disks attached to each PowerFlex cluster node | `number` | n/a | yes |
| <a name="input_is_multi_az"></a> [is\_multi\_az](#input\_is\_multi\_az) | Whether the PowerFlex cluster is deployed in single or multiple availability zones | `bool` | n/a | yes |
| <a name="input_is_balanced"></a> [is\_balanced](#input\_is\_balanced) | Deployment type, true for balanced type, false for optimized type | `bool` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
