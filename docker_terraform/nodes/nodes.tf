
variable "subnet_swarm" {
  type = string  
}

variable "sg_allow_swarm_id" {
  type = set(string)
}

variable "private_ip" {
  type = list(string) 
}

variable "Nodes_instnace_names" {
    type = list(string)
}

resource "aws_key_pair" "test_keypair" {
    key_name = "test_keypair"
    public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "Nodes" {
    ami="ami-0ff338189efb7ed37"
    instance_type = "t3.micro"
    subnet_id = var.subnet_swarm
    key_name = aws_key_pair.test_keypair.key_name
    count = length(var.Nodes_instnace_names)
    private_ip = var.private_ip[count.index]
    tags = {
      "Name" = var.Nodes_instnace_names[count.index]
    }
    connection {
    timeout = "1m"
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host = self.public_ip
    }
    provisioner "file" {
    source      = "./nodes/server-script.sh"
    destination = "/tmp/server-script.sh"
    }
    provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/server-script.sh",
      "/tmp/server-script.sh args",
    ]
    }
}

output "Nodes_instance_id" {
    value = [aws_instance.Nodes.*.id]
}

output "Nodes_instance_privte_ip" {
    value = [aws_instance.Nodes.*.private_ip]
}

