##############
# PowerFlex User
##############

module "usercreation" {
  # Here source points to the user submodule in the modules folder. You can change the value to point it according to your usecase. 
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