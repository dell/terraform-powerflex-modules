main.tf
```hcl
module "vsphere_pfmp_installation" {
  # Here the source points to the a local instance of the submodule in the modules folder, if you have and instance of the modules folder locally.
  # source = "../../modules/vsphere_pfmp_installation"

  # Here is an example of a source that pulls from the registry
  source  = "dell/modules/powerflex//modules/vsphere_pfmp_installation"
  version = "x.x.x" // pull in the latest version like "1.2.0"

  # Required
  # Ip address of the ntp server
  ntp_ip = var.ntp_ip
  # Ip address of installer node
  installer_node_ip = var.installer_node_ip
  # Ip address of node 1
  node_1_ip = var.node_1_ip
  # Ip address of node 2
  node_2_ip = var.node_2_ip
  # Ip address of node 3
  node_3_ip = var.node_3_ip

  # Optional values which if not set have default values
  ## Username to all nodes default is 'delladmin'
  # username = var.username  # default is 'delladmin'
  ## Password to all nodes default is 'delladmin'
  # password = var.password  
  ## Local path where you are running terraform to the PFMP_Config.json
  # local_path_to_pfmp_config = var.local_path_to_pfmp_config  # default is './PFMP_Config.json'
  ## This is default on Powerflex 4.6 or greater
  # destination_path_to_set_pfmp_config = var.destination_path_to_set_pfmp_config  # default is '/opt/dell/pfmp/PFMP_Installer/config/PFMP_Config.json'
  ## To use this deployment as a co res deployment
  # use_co_res = true
}

```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.1 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.copy_pfmp_config](https://registry.terraform.io/providers/hashicorp/null/3.2.1/docs/resources/resource) | resource |
| [terraform_data.install_pfmp](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [terraform_data.set_ntp](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [terraform_data.set_ntp_node1](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [terraform_data.set_ntp_node2](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [terraform_data.set_ntp_node3](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_destination_path_to_set_pfmp_config"></a> [destination\_path\_to\_set\_pfmp\_config](#input\_destination\_path\_to\_set\_pfmp\_config) | The path to the PFMP\_Config is set on the installer VM, default is '/opt/dell/pfmp/PFMP\_Installer/config/PFMP\_Config.json' | `string` | `"/opt/dell/pfmp/PFMP_Installer/config/PFMP_Config.json"` | no |
| <a name="input_installer_node_ip"></a> [installer\_node\_ip](#input\_installer\_node\_ip) | The IP address of the PowerFlex installer node. | `string` | n/a | yes |
| <a name="input_local_path_to_pfmp_config"></a> [local\_path\_to\_pfmp\_config](#input\_local\_path\_to\_pfmp\_config) | The path to the PFMP\_Config on the local machine, default is './PFMP\_Config.json' | `string` | `"./PFMP_Config.json"` | no |
| <a name="input_node_1_ip"></a> [node\_1\_ip](#input\_node\_1\_ip) | The IP address of the PowerFlex node 1. | `string` | n/a | yes |
| <a name="input_node_2_ip"></a> [node\_2\_ip](#input\_node\_2\_ip) | The IP address of the PowerFlex node 2. | `string` | n/a | yes |
| <a name="input_node_3_ip"></a> [node\_3\_ip](#input\_node\_3\_ip) | The IP address of the PowerFlex node 3. | `string` | n/a | yes |
| <a name="input_ntp_ip"></a> [ntp\_ip](#input\_ntp\_ip) | The IP address of the NTP server. | `string` | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | The password of the PowerFlex nodes and installer, default is 'delladmin' | `string` | `"delladmin"` | no |
| <a name="input_username"></a> [username](#input\_username) | The username of the PowerFlex nodes and installer, default is 'delladmin' | `string` | `"delladmin"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->