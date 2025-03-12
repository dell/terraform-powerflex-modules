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
