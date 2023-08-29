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
  mdmusername = "root"
  mdmpassword = "Password"
  mdmhost = "10.x.x.x"
  changedpassword = "Password123"
}