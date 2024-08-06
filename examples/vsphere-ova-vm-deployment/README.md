<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_vsphere"></a> [vsphere](#requirement\_vsphere) | 2.8.2 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vsphere_ova_vm_deployment"></a> [vsphere\_ova\_vm\_deployment](#module\_vsphere\_ova\_vm\_deployment) | ../../modules/vsphere-ova-vm-deployment | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_unverified_ssl"></a> [allow\_unverified\_ssl](#input\_allow\_unverified\_ssl) | Allow unverified ssl connection | `string` | `true` | no |
| <a name="input_vsphere_password"></a> [vsphere\_password](#input\_vsphere\_password) | Stores the password of vsphere\_password. | `string` | n/a | yes |
| <a name="input_vsphere_server"></a> [vsphere\_server](#input\_vsphere\_server) | Stores the host ip/fqdn of the vsphere\_server. | `string` | n/a | yes |
| <a name="input_vsphere_user"></a> [vsphere\_user](#input\_vsphere\_user) | Stores the username of vsphere\_user. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->