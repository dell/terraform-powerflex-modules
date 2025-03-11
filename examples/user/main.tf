##############
# PowerFlex User
##############

module "user_creation" {
  # Here the source points to the a local instance of the submodule in the modules folder, if you have and instance of the modules folder locally. 
  # source = "../../modules/user"

  # Here is an example of a source that pulls from the registry
  source  = "dell/modules/powerflex//modules/user"
  version = "x.x.x" // pull in the latest version like "1.2.0"

  newUserName = "user"
  userRole = "Monitor"
  userPassword = "Password1234"
  mdmUserName = "root"
  mdmPassword = "Password"
  mdmHost = "10.x.x.x"
  newPassword = "Password123"
}