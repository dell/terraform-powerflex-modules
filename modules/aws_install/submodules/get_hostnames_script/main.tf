variable "management_ips" {
  type = list(string)
  description = "the list of managemnet nodes private ips"
}

variable "host_ip" {
  type = string
  description = "the host ip to run the script on"
}
variable "user" {
  type = string
  description = "the login username on the host"
}

variable "private_key_path" {
  type    = string
}
variable "interpreter" {
  type    = list(string)
}
variable "bastion_config" {
  description = "Bastion configuration"
  type = object({
    use_bastion    = bool
    bastion_host   = string
    bastion_user   = string
    bastion_ssh_key = string
  })
}


resource "null_resource" "copy-gethosts-script" {
  connection {
    type        = "ssh"
    host        = var.host_ip
    user        = var.user
    private_key = file(var.private_key_path)
    bastion_host        = var.bastion_config.use_bastion ? var.bastion_config.bastion_host : null
    bastion_user        = var.bastion_config.use_bastion ? var.bastion_config.bastion_user : null
    bastion_private_key = file(var.bastion_config.bastion_ssh_key)
  }

  provisioner "file" {
    source      = "${path.module}/get_hostnames.sh"
    destination = "/tmp/get_hostnames.sh"
  }
}

resource "null_resource" "execute-gethosts-script" {
  connection {
    type        = "ssh"
    host        = var.host_ip
    user        = var.user
    private_key = file(var.private_key_path)
    bastion_host        = var.bastion_config.use_bastion ? var.bastion_config.bastion_host : null
    bastion_user        = var.bastion_config.use_bastion ? var.bastion_config.bastion_user : null
    bastion_private_key = file(var.bastion_config.bastion_ssh_key)
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/get_hostnames.sh",
      "/tmp/get_hostnames.sh ${join(" ", var.management_ips)} > /tmp/hostnames_output.txt"
    ]
  }
  depends_on = [null_resource.copy-gethosts-script]
}

# Define the null_resource to execute the SCP command
resource "null_resource" "scp_remote_file_bastion" {
  count = var.bastion_config.use_bastion  ? 1 : 0
  provisioner "local-exec" {
    interpreter = var.interpreter
    command = <<EOT
      scp -o StrictHostKeyChecking=no -o ProxyCommand="ssh -i ${var.bastion_config.bastion_ssh_key}  ${var.bastion_config.bastion_user}@${var.bastion_config.bastion_host} nc %h %p"   -i ${var.private_key_path} ${var.user}@${var.host_ip}:/tmp/hostnames_output.txt /tmp/.
    EOT
  }

  triggers = {
    always_run = "${timestamp()}"
  }
  depends_on = [null_resource.execute-gethosts-script]
}

# Define the null_resource to execute the SCP command
resource "null_resource" "scp_remote_file" {
  count = var.bastion_config.use_bastion  ? 0 : 1
  provisioner "local-exec" {
    interpreter = var.interpreter
    command = <<EOT
      scp -o StrictHostKeyChecking=no -i ${var.private_key_path} ${var.user}@${var.host_ip}:/tmp/hostnames_output.txt /tmp/.
    EOT
  }

  triggers = {
    always_run = "${timestamp()}"
  }
  depends_on = [null_resource.execute-gethosts-script]
}


data "local_file" "hostnames_output" {
  filename = "/tmp/hostnames_output.txt"
  depends_on = [null_resource.scp_remote_file, null_resource.scp_remote_file_bastion]
}

locals {
  hostnames = compact(split("\n", data.local_file.hostnames_output.content))
}


output "hostnames" {
  value = local.hostnames
}
