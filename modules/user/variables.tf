
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