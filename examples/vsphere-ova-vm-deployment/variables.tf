variable "vsphere_user" {
  type        = string
  description = "Stores the username of vsphere_user."
}

variable "vsphere_password" {
  type        = string
  description = "Stores the password of vsphere_password."
}

variable "vsphere_server" {
  type        = string
  description = "Stores the host ip/fqdn of the vsphere_server."
}

variable "allow_unverified_ssl" {
  type        = string
  description = "Allow unverified ssl connection"
  default = true
}
