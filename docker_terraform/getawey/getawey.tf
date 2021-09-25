resource "aws_key_pair" "Getawey_keypair" {
    key_name = "Getawey_keypair"
    public_key = file("~/.ssh/id_rsa.pub")
}

variable "subnet_swarm" {
  type = string  
}

variable "vpc_swarm_var" {
  type = string  
}

variable "ingressrules" {
  type = list(number)
  default = [80,443, 22]
}

resource "aws_instance" "Getawey" {
    ami="ami-050fdc53cf6ba8f7f"
    instance_type = "t3.micro"
    subnet_id = var.subnet_swarm
    private_ip = "10.0.0.30"
    key_name = aws_key_pair.Getawey_keypair.key_name
    tags = {
      "Name" = "Getawey"
    }
    connection {
    timeout = "1m"
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host = aws_instance.Getawey.public_ip
    }
    provisioner "file" {
    source      = "~/.ssh/id_rsa"
    destination = "/home/ec2-user/.ssh/id_rsa_remotesystem"
    }
    provisioner "file" {
    source      = "~/terraform_dante/docker_terraform/getawey/ssh_config"
    destination = "/home/ec2-user/.ssh/config"
    }
    provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum upgrade -y",
      "chmod 400 /home/ec2-user/.ssh/id_rsa_remotesystem",
      "chmod 400 /home/ec2-user/.ssh/config",
    ]
    }
}

output "Getawey_instance_id" {
    value = [aws_instance.Getawey.id]
}

output "Getawey_instance_public_ip" {
    value = [aws_instance.Getawey.public_ip]
}

