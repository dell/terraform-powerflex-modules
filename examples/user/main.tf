##############
# PowerFlex User
##############

module "usercreation" {
  source = "../../modules/user"

  username = "admin"
  password = "Password"
  endpoint = "10.x.x.x"
  newUserName = "user"
  userRole = "Monitor"
  userPassword = "Password1234"
  mdmUserName = "root"
  mdmPassword = "Password"
  mdmHost = "10.x.x.x"
  newPassword = "Password123"
}