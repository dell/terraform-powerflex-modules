

terraform {
  required_providers {
    powerflex = {
      version = "1.2.0"
      source  = "registry.terraform.io/dell/powerflex"
    }
    null = {  
      source = "hashicorp/null"  
      version = "3.2.1"  
    }
  }
    
}
provider "powerflex" {
  username = var.username
  password = var.password
  endpoint = var.endpoint
  insecure = true
  timeout  = 120
}

provider "null" {}