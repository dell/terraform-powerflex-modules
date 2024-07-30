terraform {
   required_providers {
     powerflex = {
       version = ">=1.6.0"
       source  = "registry.terraform.io/dell/powerflex"
     }
   }
 }


provider "powerflex" {
  username = var.powerflex_config.username
  password = var.powerflex_config.password
  endpoint = var.powerflex_config.endpoint
  insecure = true
  timeout  = 120
}
