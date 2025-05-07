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

locals {
  vm_size = var.cluster.deployment_type == "balanced" ? var.vm_size.balanced : (var.cluster.deployment_type == "optimized_v1" ? var.vm_size.optimized_v1 : var.vm_size.optimized_v2)

  is_balanced = var.cluster.deployment_type == "balanced" ? true : false

  data_disk_count = var.cluster.deployment_type == "balanced" ? var.cluster.data_disk_count : (var.cluster.deployment_type == "optimized_v1" ? 4 : 8)

  availability_zones = var.cluster.is_multi_az ? var.availability_zones : [element(var.availability_zones, 0)]

  storage_instance_image_reference = {
    publisher = var.image_reference.publisher
    offer     = var.image_reference.offer
    sku       = var.image_reference.storage460
    version   = "4.6.0"
  }

  installer_image_reference = {
    publisher = var.image_reference.publisher
    offer     = var.image_reference.offer
    sku       = var.image_reference.installer460
    version   = "4.6.0"
  }

  invalid_rg_name = "!!i_am_not_a_valid_name!!"
  resource_group  = coalesce(var.existing_resource_group, local.invalid_rg_name) == local.invalid_rg_name ? azurerm_resource_group.pflex_rg[0] : data.azurerm_resource_group.pflex_rg[0]
}

## Create resource group
resource "azurerm_resource_group" "pflex_rg" {
  count    = coalesce(var.existing_resource_group, local.invalid_rg_name) == local.invalid_rg_name ? 1 : 0
  name     = "${var.prefix}-rg"
  location = var.location
}

data "azurerm_resource_group" "pflex_rg" {
  count = coalesce(var.existing_resource_group, local.invalid_rg_name) != local.invalid_rg_name ? 1 : 0
  name  = var.existing_resource_group
}

## Create Network Security Group and rule
resource "azurerm_network_security_group" "pflex_nsg" {
  name                = "${var.prefix}-nsg"
  location            = local.resource_group.location
  resource_group_name = local.resource_group.name

  dynamic "security_rule" {
    for_each = var.nsg_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_address_prefix      = security_rule.value.source_address_prefix
      source_port_range          = security_rule.value.source_port_range
      destination_address_prefix = security_rule.value.destination_address_prefix
      destination_port_range     = security_rule.value.destination_port_range
    }
  }
}

## NSG for bastion
## Get from https://github.com/Azure/terraform/blob/master/quickstart/201-machine-learning-moderately-secure/bastion.tf
resource "azurerm_network_security_group" "bastion_nsg" {
  count               = var.enable_bastion ? 1 : 0
  name                = "${var.prefix}-nsg-bastion"
  location            = local.resource_group.location
  resource_group_name = local.resource_group.name

  security_rule {
    name                       = "AllowHTTPSInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowGatewayManagerInbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "GatewayManager"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowAzureLBInbound"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowBastionHostCommunication"
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["5701", "8080"]
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }
  security_rule {
    name                       = "AllowRdpSshOutbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "3389"]
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }
  security_rule {
    name                       = "AllowBastionHostCommunicationOutbound"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["5701", "8080"]
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }
  security_rule {
    name                       = "AllowAzureCloudOutbound"
    priority                   = 120
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["443"]
    source_address_prefix      = "*"
    destination_address_prefix = "AzureCloud"
  }
  security_rule {
    name                       = "AllowGetSessionInformation"
    priority                   = 130
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80"]
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }
}

## Create virtual network
resource "azurerm_virtual_network" "pflex_network" {
  name                = "${var.prefix}-vnet"
  address_space       = [var.vnet_address_space]
  location            = local.resource_group.location
  resource_group_name = local.resource_group.name

  dynamic "subnet" {
    for_each = var.subnets
    content {
      name           = subnet.value.name
      address_prefix = subnet.value.prefix
      security_group = azurerm_network_security_group.pflex_nsg.id
    }
  }

  dynamic "subnet" {
    for_each = var.enable_bastion ? [var.bastion_subnet] : []
    content {
      name           = subnet.value.name
      address_prefix = subnet.value.prefix
      security_group = azurerm_network_security_group.bastion_nsg[0].id
    }
  }
}

## Create bastion
resource "azurerm_public_ip" "bastion_public_ip" {
  count               = var.enable_bastion ? 1 : 0
  name                = "${var.prefix}-bastion-public-ip"
  location            = local.resource_group.location
  resource_group_name = local.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion_host" {
  count               = var.enable_bastion ? 1 : 0
  name                = "${var.prefix}-bastion"
  location            = local.resource_group.location
  resource_group_name = local.resource_group.name
  tunneling_enabled   = true
  sku                 = "Standard"

  ip_configuration {
    name                 = "${var.prefix}-bastion-configuration"
    subnet_id            = [for output in azurerm_virtual_network.pflex_network.subnet[*] : output.id if output.name == var.subnets[0].name][0]
    public_ip_address_id = azurerm_public_ip.bastion_public_ip[0].id
  }
}


## Create jumphost
resource "azurerm_network_interface" "jumphost_nic" {
  count               = var.enable_jumphost ? 1 : 0
  name                = "${var.prefix}-jumphost-nic"
  location            = local.resource_group.location
  resource_group_name = local.resource_group.name

  ip_configuration {
    name                          = "nic_configuration"
    subnet_id                     = [for output in azurerm_virtual_network.pflex_network.subnet[*] : output.id if output.name == var.subnets[0].name][0]
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "jumphost_vm" {
  count                 = var.enable_jumphost ? 1 : 0
  name                  = "${var.prefix}-jumphost-vm"
  location              = local.resource_group.location
  resource_group_name   = local.resource_group.name
  zone                  = local.availability_zones[0]
  network_interface_ids = [azurerm_network_interface.jumphost_nic[0].id]
  size                  = var.vm_size.jumphost
  admin_username        = var.login_credential.username
  admin_password        = var.login_credential.password
  computer_name         = "jumphost"

  os_disk {
    name                 = "${var.prefix}-jumphost-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
  source_image_reference {
    publisher = var.jumphost_image_reference.publisher
    offer     = var.jumphost_image_reference.offer
    sku       = var.jumphost_image_reference.sku
    version   = var.jumphost_image_reference.version
  }
}

## Optional SQL VM for workload validation testing
resource "azurerm_network_interface" "sqlvm_nic" {
  count               = var.enable_sql_workload_vm ? 1 : 0
  name                = "${var.prefix}-sqlvm-nic"
  location            = local.resource_group.location
  resource_group_name = local.resource_group.name

  ip_configuration {
    name                          = "nic_configuration"
    subnet_id                     = [for output in azurerm_virtual_network.pflex_network.subnet[*] : output.id if output.name == var.subnets[0].name][0]
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "sqlvm" {
  count                 = var.enable_sql_workload_vm ? 1 : 0
  name                  = "${var.prefix}-sql-vm"
  location              = local.resource_group.location
  resource_group_name   = local.resource_group.name
  zone                  = local.availability_zones[0]
  network_interface_ids = [azurerm_network_interface.sqlvm_nic[0].id]
  size                  = var.vm_size.sqlvm
  admin_username        = var.login_credential.username
  admin_password        = var.login_credential.password
  computer_name         = "sqlvm"

  os_disk {
    name                 = "${var.prefix}-sqlvm-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = var.os_disk_size_gb
  }

  source_image_reference {
    publisher = var.sqlvm_image_reference.publisher
    offer     = var.sqlvm_image_reference.offer
    sku       = var.sqlvm_image_reference.sku
    version   = var.sqlvm_image_reference.version
  }
}

resource "azurerm_mssql_virtual_machine" "sqlvm" {
  count                            = var.enable_sql_workload_vm ? 1 : 0
  virtual_machine_id               = azurerm_windows_virtual_machine.sqlvm[0].id
  sql_license_type                 = "PAYG"
  r_services_enabled               = false
  sql_connectivity_port            = 1433
  sql_connectivity_type            = "PRIVATE"
  sql_connectivity_update_password = "PowerFlex123!"
  sql_connectivity_update_username = "pflexuser"

  sql_instance {
    max_server_memory_mb = "12000"
  }
}

data "azurerm_shared_image_version" "storage_instance_ami" {
  count               = var.storage_instance_gallary_image != null ? 1 : 0
  name                = var.storage_instance_gallary_image.name
  image_name          = var.storage_instance_gallary_image.image_name
  gallery_name        = var.storage_instance_gallary_image.gallery_name
  resource_group_name = var.storage_instance_gallary_image.resource_group_name
}

data "azurerm_shared_image_version" "installer_ami" {
  count               = var.installer_gallary_image != null ? 1 : 0
  name                = var.installer_gallary_image.name
  image_name          = var.installer_gallary_image.image_name
  gallery_name        = var.installer_gallary_image.gallery_name
  resource_group_name = var.installer_gallary_image.resource_group_name
}

## Create storage instance
# https://www.dell.com/support/manuals/zh-hk/scaleio/flex-cloud-azure-deploy-45x/create-the-virtual-machine-for-the-storage-instance?guid=guid-c87fe065-5e65-4c96-84b9-a8f5065230cd&lang=en-us
resource "azurerm_network_interface" "storage_instance_nic" {
  count                          = var.cluster.node_count
  name                           = "${var.prefix}-nic-${count.index}"
  location                       = local.resource_group.location
  resource_group_name            = local.resource_group.name
  accelerated_networking_enabled = var.enable_accelerated_networking

  ip_configuration {
    name                          = "nic_configuration"
    subnet_id                     = [for output in azurerm_virtual_network.pflex_network.subnet[*] : output.id if output.name == var.subnets[0].name][0]
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "storage_instance" {
  count                 = var.cluster.node_count
  name                  = "${var.prefix}-vm-${count.index}"
  location              = local.resource_group.location
  resource_group_name   = local.resource_group.name
  network_interface_ids = [azurerm_network_interface.storage_instance_nic[count.index].id]
  size                  = local.vm_size
  zone                  = local.availability_zones[count.index % length(local.availability_zones)]

  os_disk {
    name                 = "${var.prefix}-vm-${count.index}-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = var.os_disk_size_gb
  }

  source_image_id = var.storage_instance_gallary_image != null ? data.azurerm_shared_image_version.storage_instance_ami[0].id : null

  dynamic "source_image_reference" {
    for_each = var.storage_instance_gallary_image == null ? [1] : []
    content {
      publisher = local.storage_instance_image_reference.publisher
      offer     = local.storage_instance_image_reference.offer
      sku       = local.storage_instance_image_reference.sku
      version   = local.storage_instance_image_reference.version
    }
  }

  dynamic "plan" {
    for_each = var.storage_instance_gallary_image == null ? [1] : []
    content {
      name      = local.storage_instance_image_reference.sku
      publisher = local.storage_instance_image_reference.publisher
      product   = local.storage_instance_image_reference.offer
    }
  }

  disable_password_authentication = false
  admin_username                  = var.login_credential.username
  admin_password                  = var.login_credential.password
  admin_ssh_key {
    username   = var.login_credential.username
    public_key = file("${var.ssh_key.public}")
  }

  # https://learn.microsoft.com/en-us/azure/virtual-machines/custom-data
  # cloud-init. By default, this agent processes custom data.
  # It doesn't wait for custom data configurations from the user 
  #   to finish before reporting to the platform that the VM is ready.
  custom_data = filebase64("${path.module}/disable_firewall.sh")
  # custom_data = index < 3 ? filebase64("${path.module}/init_pfmp_config.sh") : null

  # TODO:
  # May not be needed when https://github.com/hashicorp/terraform-provider-azurerm/issues/20723 is implemented
  provisioner "local-exec" {
    command = count.index > 2 ? "whoami" : <<-EOT
      az disk update -n ${var.prefix}-vm-${count.index}-os-disk -g ${local.resource_group.name} --set tier=P40 --no-wait
      az disk wait --updated -n ${var.prefix}-vm-${count.index}-os-disk -g ${local.resource_group.name}
    EOT
  }
}

resource "azurerm_managed_disk" "data_disks" {
  for_each = {
    for i in range(local.is_balanced ? (var.cluster.node_count * var.cluster.data_disk_count) : 0) : i => {
      vm_index   = floor(i / var.cluster.data_disk_count)
      disk_index = i % var.cluster.data_disk_count
    }
  }
  name                 = "${var.prefix}-vm-${each.value.vm_index}-data-disk-${each.value.disk_index}"
  location             = local.resource_group.location
  resource_group_name  = local.resource_group.name
  storage_account_type = "PremiumV2_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.cluster.data_disk_size_gb
  zone                 = local.availability_zones[each.value.vm_index % length(local.availability_zones)]
  disk_iops_read_write = var.data_disk_iops_read_write
  disk_mbps_read_write = var.data_disk_mbps_read_write
  logical_sector_size  = var.data_disk_logical_sector_size
}

resource "azurerm_virtual_machine_data_disk_attachment" "vm_data_disk_attachment" {
  for_each = {
    for i in range(local.is_balanced ? (var.cluster.node_count * var.cluster.data_disk_count) : 0) : i => {
      vm_index   = floor(i / var.cluster.data_disk_count)
      disk_index = i % var.cluster.data_disk_count
    }
  }
  managed_disk_id    = azurerm_managed_disk.data_disks[each.key].id
  virtual_machine_id = azurerm_linux_virtual_machine.storage_instance[each.value.vm_index].id
  lun                = each.value.disk_index
  caching            = "None"
}


## Create Installer
resource "azurerm_network_interface" "installer_nic" {
  name                = "${var.prefix}-installer-nic"
  location            = local.resource_group.location
  resource_group_name = local.resource_group.name

  ip_configuration {
    name                          = "nic_configuration"
    subnet_id                     = [for output in azurerm_virtual_network.pflex_network.subnet[*] : output.id if output.name == var.subnets[0].name][0]
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "installer" {
  name                  = "${var.prefix}-installer-vm"
  location              = local.resource_group.location
  resource_group_name   = local.resource_group.name
  network_interface_ids = [azurerm_network_interface.installer_nic.id]
  size                  = var.vm_size.installer
  zone                  = local.availability_zones[0]

  os_disk {
    name                 = "${var.prefix}-installer-vm-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = var.os_disk_size_gb
  }

  source_image_id = var.installer_gallary_image != null ? data.azurerm_shared_image_version.installer_ami[0].id : null

  dynamic "source_image_reference" {
    for_each = var.installer_gallary_image == null ? [1] : []
    content {
      publisher = local.installer_image_reference.publisher
      offer     = local.installer_image_reference.offer
      sku       = local.installer_image_reference.sku
      version   = local.installer_image_reference.version
    }
  }

  dynamic "plan" {
    for_each = var.installer_gallary_image == null ? [1] : []
    content {
      name      = local.installer_image_reference.sku
      publisher = local.installer_image_reference.publisher
      product   = local.installer_image_reference.offer
    }
  }

  disable_password_authentication = false
  admin_username                  = var.login_credential.username
  admin_password                  = var.login_credential.password
  admin_ssh_key {
    username   = var.login_credential.username
    public_key = file("${var.ssh_key.public}")
  }

  custom_data = base64encode(templatefile("${path.module}/init_pfmp_config.sh", {
    nodes_name      = join(",", azurerm_linux_virtual_machine.storage_instance[*].name)
    nodes_ip        = join(",", azurerm_network_interface.storage_instance_nic[*].ip_configuration.0.private_ip_address)
    lb_ip           = var.pfmp_lb_ip
    login_username  = var.login_credential.username
    login_password  = var.login_credential.password
    sshkey          = file("${var.ssh_key.private}")
    data_disk_count = local.data_disk_count
    is_multi_az     = var.cluster.is_multi_az
    is_balanced     = local.is_balanced
  }))

  extensions_time_budget = "PT2H"
}

# TODO:
# According to https://learn.microsoft.com/en-us/azure/virtual-machines/linux/run-command-managed,
# it supports for long running (hours/days) scripts, but it still seems to have 90 minutes limit.
# Raised https://github.com/hashicorp/terraform-provider-azurerm/issues/27428
resource "azurerm_virtual_machine_run_command" "wait_pfmp_installation1" {
  location           = local.resource_group.location
  name               = "wait_pfmp_installation1"
  virtual_machine_id = azurerm_linux_virtual_machine.installer.id

  source {
    script = file("${path.module}/wait_pfmp_installation.sh")
  }

  timeouts {
    create = "2h"
  }
}

# The installation would take around 2 ~ 2.5hours, add a second wait to ensure the installation finishes.
resource "azurerm_virtual_machine_run_command" "wait_pfmp_installation2" {
  location           = local.resource_group.location
  name               = "wait_pfmp_installation2"
  virtual_machine_id = azurerm_linux_virtual_machine.installer.id

  source {
    script = azurerm_virtual_machine_run_command.wait_pfmp_installation1.instance_view[0].output == "true\n" ? "whoami" : file("${path.module}/wait_pfmp_installation.sh")
  }

  timeouts {
    create = "2h"
  }
}

# # https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-linux
# # The script is allowed 90 minutes to run. Anything longer results in a failed provision of the extension.
# resource "azurerm_virtual_machine_extension" "installer_script" {
#   name                 = "init_pfmp_config"
#   virtual_machine_id   = azurerm_linux_virtual_machine.installer.id
#   publisher            = "Microsoft.Azure.Extensions"
#   type                 = "CustomScript"
#   type_handler_version = "2.0"

#   settings = <<SETTINGS
#     {
#       "script": "${base64encode(templatefile("${path.module}/init_pfmp_config.sh", {
#   nodes_name     = "${join(",", var.nodes_name)}"
#   nodes_ip       = "${join(",", var.nodes_ip)}"
#   lb_ip          = "${var.lb_ip}"
#   login_username = "${var.login_username}"
#   login_password = "${var.login_password}"
# }))}"
#     }
# SETTINGS
# }


## Create Load Balancer
resource "azurerm_lb" "load_balancer" {
  name                = "${var.prefix}-lb"
  location            = local.resource_group.location
  resource_group_name = local.resource_group.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "${var.prefix}-lb-ip"
    private_ip_address_allocation = "Static"
    private_ip_address            = var.pfmp_lb_ip
    subnet_id                     = [for output in azurerm_virtual_network.pflex_network.subnet[*] : output.id if output.name == var.subnets[0].name][0]
    zones                         = local.availability_zones
  }
}

resource "azurerm_lb_probe" "pfmp_probe" {
  loadbalancer_id     = azurerm_lb.load_balancer.id
  name                = "pfmp-probe"
  port                = 30400
  interval_in_seconds = 5
  protocol            = "Tcp"
}

resource "azurerm_lb_backend_address_pool" "lb_be_pool" {
  name            = "pfmp-pool"
  loadbalancer_id = azurerm_lb.load_balancer.id
}

resource "azurerm_lb_rule" "lb-rules" {
  loadbalancer_id                = azurerm_lb.load_balancer.id
  name                           = "pfmp-rule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 30400
  frontend_ip_configuration_name = "${var.prefix}-lb-ip"
  probe_id                       = azurerm_lb_probe.pfmp_probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_be_pool.id]

}

resource "azurerm_network_interface_backend_address_pool_association" "lb_be_pool_association" {
  count                   = 3
  network_interface_id    = azurerm_network_interface.storage_instance_nic[count.index].id
  ip_configuration_name   = azurerm_network_interface.storage_instance_nic[count.index].ip_configuration.0.name
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_be_pool.id
}

output "bastion_tunnel" {
  value = length(azurerm_bastion_host.bastion_host) > 0 ? {
    bastion_name   = azurerm_bastion_host.bastion_host[0].name
    resource_group = local.resource_group.name
    installer_id   = azurerm_linux_virtual_machine.installer.id
  } : null
}

output "sds_nodes" {
  value = [
    for i in range(var.cluster.node_count) :
    {
      "hostname" = azurerm_linux_virtual_machine.storage_instance[i].name
      "ip"       = azurerm_network_interface.storage_instance_nic[i].ip_configuration.0.private_ip_address
    }
  ]
}

output "pfmp_ip" {
  value = var.pfmp_lb_ip
}
