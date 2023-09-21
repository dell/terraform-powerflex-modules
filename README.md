## Features
Manages user on a PowerFlex array. User resource can be used to create, update role and delete the user from the PowerFlex array. Once the user is created, it is mandatory to change the password when it's logged in for the first time. The intent of this user submodule is to change the password during it's first login.

`user`:

```hcl
module "iam_account" {
  source  = "terraform-powerflex-modules/modules/user"

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
```

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Run `terraform destroy` when you don't need these resources.

## Requirements

| Name | Version |
|------|---------|
| Terraform | 1.3.x <br> 1.5.x | 
| PowerFlex Provider | v1.2.0 |




