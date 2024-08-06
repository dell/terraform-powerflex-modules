
terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.8.2"
    }
  }
}

provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = var.allow_unverified_ssl
  api_timeout          = 10
}