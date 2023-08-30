
variable "username" {
  type        = string
  description = "Stores the username of PowerFlex host."
}

variable "password" {
  type        = string
  description = "Stores the password of PowerFlex host."
}

variable "endpoint" {
  type        = string
  description = "Stores the endpoint of PowerFlex host. eg: https://10.1.1.1:443, here 443 is port where API requests are getting accepted"
}

variable "newUserName" {
  type        = string
  description = "Name of the new user."
}

variable "userRole" {
  type        = string
  description = "Role of the new user."
}

variable "userPassword" {
  type        = string
  description = "Password of the new user."
}

variable "mdmUserName" {
  type        = string
  description = "Primary MDM username required for connecting to the Primary MDM."
}

variable "mdmPassword" {
  type        = string
  description = "Primary MDM password required for connecting to the Primary MDM."
}


variable "mdmHost" {
  type        = string
  description = "Primary MDM host required for connecting to the Primary MDM."
}

variable "newPassword" {
  type        = string
  description = "New password required for the first login."
}