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

variable "prefix" {
  type        = string
  description = "Prefix for Azure resource names."
}

variable "existing_resource_group" {
  type        = string
  default     = null
  description = "Name of existing resource group to use. If not set, a new resource group will be created."
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Location for Azure resources."
}

variable "vnet_address_space" {
  type        = string
  default     = "10.2.0.0/16"
  description = "Virtual network address space."
}

variable "subnets" {
  type = list(object({
    name   = string
    prefix = string
  }))
  default = [{
    name   = "BlockStorageSubnet"
    prefix = "10.2.0.0/24"
  }]
  validation {
    condition = (
      length(var.subnets) > 0
    )
    error_message = "Must contain at least one."
  }
  description = "List of subnets for the virtual network."
}

variable "enable_bastion" {
  type        = bool
  default     = false
  description = "Enable bastion."
}

variable "bastion_subnet" {
  type = object({
    name   = string
    prefix = string
  })
  default = {
    name   = "AzureBastionSubnet"
    prefix = "10.2.1.0/26"
  }
  description = "Bastion subnet."
}

variable "enable_jumphost" {
  type        = bool
  default     = false
  description = "Enable jumphost."
}

variable "enable_sql_workload_vm" {
  type        = bool
  default     = false
  description = "Enable sql workload vm."
}

# TODO: Add more validation according to:
# https://infohub.delltechnologies.com/en-us/l/dell-apex-block-storage-for-microsoft-azure/azure-storage-considerations/
variable "cluster" {
  type = object({
    node_count        = number
    is_multi_az       = bool
    deployment_type   = string
    data_disk_count   = number
    data_disk_size_gb = number
  })

  default = {
    node_count        = 5
    is_multi_az       = false
    deployment_type   = "balanced"
    data_disk_count   = 20
    data_disk_size_gb = 512
  }

  validation {
    condition     = var.cluster.is_multi_az ? var.cluster.node_count >= 6 : var.cluster.node_count >= 5
    error_message = "The minimum node count is 5 for single availability zone and 6 for multiple availability zone."
  }

  validation {
    condition     = var.cluster.node_count <= 128
    error_message = "Maximum SDSs per protection domain is 128."
  }

  validation {
    condition     = var.cluster.deployment_type == "balanced" ? var.cluster.data_disk_count * var.cluster.data_disk_size_gb <= 160 * 1024 : true
    error_message = "Maximum raw capacity per SDS is 160TB."
  }

  validation {
    condition     = var.cluster.deployment_type == "balanced" ? var.cluster.data_disk_count * var.cluster.node_count <= 300 : (var.cluster.deployment_type == "optimized_v1" ? 4 * var.cluster.node_count <= 300 : 8 * var.cluster.node_count <= 300)
    error_message = "Maximum devices per storage pool is 300."
  }

  validation {
    condition = var.cluster.deployment_type == "balanced" ? (
      (var.cluster.data_disk_count * var.cluster.data_disk_size_gb * var.cluster.node_count <= 4 * 1024 * 1024) &&
      (var.cluster.data_disk_count * var.cluster.data_disk_size_gb * var.cluster.node_count >= 720)
      ) : (
      var.cluster.deployment_type == "optimized_v1" ? 4 * 1.92 * 1024 * var.cluster.node_count <= 4 * 1024 * 1024
      : 8 * 1.92 * 1024 * var.cluster.node_count <= 4 * 1024 * 1024
    )
    error_message = "Total size of all volumes per storage pool is 4PB and Minimum storage pool size is 720GB."
  }

  validation {
    condition     = contains(["balanced", "optimized_v1", "optimized_v2"], var.cluster.deployment_type)
    error_message = "Deployment type must be \"balanced\", \"optimized_v1\" or \"optimized_v2\"."
  }

  validation {
    condition = var.cluster.deployment_type == "balanced" ? (
      var.cluster.data_disk_count >= 1 &&
      var.cluster.data_disk_count <= 24
    ) : true
    error_message = "Data disk count must be between 1 and 24."
  }

  validation {
    condition     = contains([256, 512, 1024, 2048], var.cluster.data_disk_size_gb)
    error_message = "Data disk size must be 256, 512, 1024 or 2048 GB."
  }

  description = "PowerFlex cluster configuration, including: node number, deploy in single or multiple availability zones, deployment type can be 'balanced', 'optimized_v1' or 'optimized_v2', the number of data disks attached to a single node and the size of each."
}

variable "enable_accelerated_networking" {
  type        = bool
  default     = true
  description = "Enable accelerated networking for the cluster."
}

variable "availability_zones" {
  type        = list(string)
  default     = ["1", "2", "3"]
  description = "Azure availability zones."
}

# https://www.dell.com/support/manuals/zh-hk/scaleio/flex-cloud-azure-deploy-45x/create-the-virtual-machine-for-the-storage-instance?guid=guid-c87fe065-5e65-4c96-84b9-a8f5065230cd&lang=en-us
variable "vm_size" {
  type = object({
    jumphost     = string
    installer    = string
    sqlvm        = string
    balanced     = string
    optimized_v1 = string
    optimized_v2 = string
  })
  default = {
    jumphost     = "Standard_D2s_v3"
    installer    = "Standard_D4s_v3"
    sqlvm        = "Standard_D4ds_v5"
    balanced     = "Standard_F48s_v2"
    optimized_v1 = "Standard_L32as_v3"
    optimized_v2 = "Standard_L64as_v3"
  }
  description = "Azure VM size."
}

variable "os_disk_size_gb" {
  type        = number
  default     = 512
  description = "Azure VM OS disk size in GB."
}

# https://azuremarketplace.microsoft.com/en-us/marketplace/apps/dellemc.dell_apex_block_storage
# az vm image list --all --publisher "dellemc"
# az vm image show --publisher "dellemc" --offer "dell_apex_block_storage" --sku "apexblockstorage-4_6_0" --version "4.6.0" --json
# sku: apexblockstorage, installer45, apexblockstorage-4_6_0, apexblockstorageinstaller-4_6_0
# version: 4.5.0, 4.6.0

variable "image_reference" {
  type = object({
    publisher    = string
    offer        = string
    storage460   = string
    storage450   = string
    installer460 = string
    installer450 = string
  })
  default = {
    publisher    = "dellemc"
    offer        = "dell_apex_block_storage"
    storage460   = "apexblockstorage-4_6_0"
    storage450   = "apexblockstorage"
    installer460 = "apexblockstorageinstaller-4_6_0"
    installer450 = "installer45"
  }
  description = "PowerFlex VM default image in Azure marketplace. Values from https://azuremarketplace.microsoft.com/en-us/marketplace/apps/dellemc.dell_apex_block_storage."
}

variable "storage_instance_gallary_image" {
  type = object({
    name                = string
    image_name          = string
    gallery_name        = string
    resource_group_name = string
  })
  default     = null
  description = "PowerFlex storage instance image in local gallary. If set, the storage instance vm will be created from this image."
}

variable "installer_gallary_image" {
  type = object({
    name                = string
    image_name          = string
    gallery_name        = string
    resource_group_name = string
  })
  default     = null
  description = "PowerFlex installer image in local gallary. If set, the installer vm will be created from this image."
}

variable "jumphost_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
  description = "Jumphost image."
}

variable "sqlvm_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "microsoftsqlserver"
    offer     = "sql2022-ws2022"
    sku       = "sqldev-gen2"
    version   = "16.0.240923"
  }
  description = "Sqlvm image."
}

variable "login_credential" {
  type = object({
    username = string
    password = string
  })
  sensitive   = true
  description = "Login credential for Azure VMs."
}

variable "ssh_key" {
  type = object({
    public  = string
    private = string
  })
  description = "SSH key pair for Azure VMs."
}

variable "data_disk_iops_read_write" {
  type        = number
  default     = 4000
  description = "The number of IOPS allowed for this disk. Please refer to https://www.dell.com/support/manuals/en-hk/scaleio/flex-cloud-azure-deploy-45x/create-the-virtual-machine-for-the-storage-instance?guid=guid-c87fe065-5e65-4c96-84b9-a8f5065230cd&lang=en-us."
}

variable "data_disk_mbps_read_write" {
  type        = number
  default     = 125
  description = "The bandwidth allowed for this disk. Please refer to https://www.dell.com/support/manuals/en-hk/scaleio/flex-cloud-azure-deploy-45x/create-the-virtual-machine-for-the-storage-instance?guid=guid-c87fe065-5e65-4c96-84b9-a8f5065230cd&lang=en-us."
}

variable "data_disk_logical_sector_size" {
  type    = number
  default = 512

  validation {
    condition     = contains([512, 4096], var.data_disk_logical_sector_size)
    error_message = "Data disk logical sector size must either be 512 or 4096."
  }
  description = "Logical Sector Size. Possible values are: 512 and 4096. Please refer to https://www.dell.com/support/manuals/en-hk/scaleio/flex-cloud-azure-deploy-45x/create-the-virtual-machine-for-the-storage-instance?guid=guid-c87fe065-5e65-4c96-84b9-a8f5065230cd&lang=en-us."
}

variable "pfmp_lb_ip" {
  type        = string
  default     = "10.2.0.200"
  description = "Load balancer IP for PFMP service."
}

variable "nsg_rules" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = [
    {
      name                       = "PowerFlex_HTTPs_from_inside"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "PowerFlex_Gateway_8080"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "8080"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "PowerFlex_SSO_internal_pod_listener"
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "8083"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "PowerFlex_SDR_listener"
      priority                   = 130
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "11088"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "PowerFlex_SDS_listener_Tcp_7072"
      priority                   = 140
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "7072"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "PowerFlex_MDM_peer_connection"
      priority                   = 150
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "7611"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "PowerFlex_ActiveMQ_1"
      priority                   = 160
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "61714"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "PowerFlex_ActiveMQ_2"
      priority                   = 170
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "8161"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "PowerFlex_Thin_Deployer"
      priority                   = 180
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "9433"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "PowerFlex_SDS_listener_Udp_9098"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "9098"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "PowerFlex_Gateway_80"
      priority                   = 210
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "PowerFlex"
      priority                   = 220
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "28765"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "PowerFlex_SDS_listener_Udp_9099"
      priority                   = 230
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "9099"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "PowerFlex_SDS_listener_Udp_7072"
      priority                   = 240
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "7072"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "PowerFlex_ActiveMQ"
      priority                   = 250
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "61613"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "PowerFlex_LIA_listener"
      priority                   = 260
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "9099"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "PowerFlex_Gateway_8443"
      priority                   = 270
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "8443"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "PowerFlex_AMS_and_MDM_listener"
      priority                   = 280
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "6611"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "PowerFlex_MDM_Cluster_member"
      priority                   = 290
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "9011"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "Default_mTLS_port_for_MDM"
      priority                   = 300
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "8611"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "RKE2_server_and_agent_nodes_Canal_CNI_with_WireGuard_IPv6_dual-stack"
      priority                   = 310
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "51821"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "RKE2_Cilium_CNI_health_checks"
      priority                   = 320
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Icmp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "RKE2_NodePort_port_range"
      priority                   = 330
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "30000-32767"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "RKE2_server_and_agent_nodes_Calico_CNI_with_VXLAN"
      priority                   = 340
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "4789"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "RKE2_server_and_agent_nodes_kubelet"
      priority                   = 350
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "10250"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "RKE2_agent_nodes_Kubernetes_API"
      priority                   = 360
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "9345"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "RKE2_docker-registry_Udp"
      priority                   = 370
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "50"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "NodePort_access_from_proxy"
      priority                   = 380
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "31550"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "RKE2_Kubernetes_API"
      priority                   = 390
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "6443"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "RKE2_cert_manager"
      priority                   = 400
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "9402"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "RKE2_server_and_agent_nodes_Canal_CNI_with_WireGuard_IPv4"
      priority                   = 410
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "51820"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "RKE2_docker-registry_Tcp"
      priority                   = 420
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "50"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "RKE2_server_and_agent_nodes_Cilium_CNI_VXLAN_required_only_for_Flanner_VXLAN"
      priority                   = 430
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "8472"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "RKE2_server_nodes_etcd_peer_port"
      priority                   = 440
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "2380"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "RKE2_server_and_agent_nodes_Calico_CNI_with_BGP"
      priority                   = 450
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "179"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "RKE2_server_and_agent_nodes_Calico_Typha_health_checks"
      priority                   = 460
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "9098"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "RKE2_server_and_agent_nodes_Calico_Canal_CNI_health_checks"
      priority                   = 470
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "9099"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "Allow_ssh_from_installer"
      priority                   = 480
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "Allow_SSH_from_proxy"
      priority                   = 490
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "RKE2_server_and_agent_nodes_Calico_CNI_with_Typha"
      priority                   = 500
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "5473"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "RKE2_server_nodes_etcd_client_port"
      priority                   = 510
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "2379"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "RKE2_server_and_agent_nodes_Cilium_CNI_health_checks"
      priority                   = 520
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "4240"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    { name                   = "RKE2-docker-registry"
      priority               = 530
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "5000"
      source_address_prefix  = "VirtualNetwork"
    destination_address_prefix = "*" },
    {
      name                       = "RKE2-docker-registry-udp"
      priority                   = 540
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "5000"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "PowerFlex-Core-SDT-4420udp"
      priority                   = 550
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "4420"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "PowerFlex-Core-SDT-4420tcp"
      priority                   = 560
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "4420"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "PowerFlex-Core-SDT-12200tcp"
      priority                   = 570
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "12200"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "PowerFlex-Core-SDT-12200udp"
      priority                   = 580
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "12200"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "PowerFlex-Core-SDT-8009tcp"
      priority                   = 590
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "8009"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "PowerFlex-Core-SDT-8009udp"
      priority                   = 600
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "8009"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "Allow_SMB_Share_UDP"
      priority                   = 610
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "137-138"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "Allow_SMB_Share_TCP"
      priority                   = 620
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "445"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "PowerFlex_gw_core_installation_upload_files"
      priority                   = 900
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "53"
      source_address_prefix      = "10.42.0.0/24"
      destination_address_prefix = "*"
    },
    {
      name                       = "pod_to_pod_connectivity"
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "10.42.0.0/24"
      destination_address_prefix = "*"
    },
    {
      name                       = "Allow-UDP-4789_for-VXLAN"
      priority                   = 1200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "4789"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "INTERNAL-ALLOW-RDP-UDP"
      priority                   = 700
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "INTERNAL-ALLOW-RDP-TCP"
      priority                   = 710
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    }
  ]
  description = "Network security rules. Please refer to https://www.dell.com/support/manuals/en-hk/scaleio/flex-cloud-azure-deploy-45x/network-security-rules?guid=guid-952be9de-35c0-4f1a-bd2e-36b89c756b7a&lang=en-us."
}
