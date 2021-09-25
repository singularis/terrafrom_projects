variable "vpc_swarm_var" {
  type = string  
}

variable "ingressrules" {
  type = list(number)
  default = [80,443, 22, 2376, 2377, 7946, 4789]
}


resource "aws_default_security_group" "default" {
    vpc_id = var.vpc_swarm_var
    tags = {
      "Name" = "Swarm_default"
    }
    dynamic "ingress" {
        iterator= port
        for_each=var.ingressrules
        content {
        cidr_blocks = [ "176.37.28.177/32" ]
        description = "EgressOutside"
        from_port = port.value
        to_port = port.value
        protocol = "TCP"
        ipv6_cidr_blocks = [ "::/128" ]
        security_groups = []
        prefix_list_ids = []
        self = false
        }
    }
    ingress {
        cidr_blocks = [ "10.0.0.0/16" ]
        description = "HTTPS"
        from_port = 0
        to_port = 65535
        protocol = "All"
        ipv6_cidr_blocks = [ "::/128" ]
        security_groups = []
        prefix_list_ids = []
        self = false
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    }

output "sg_allow_swarm_id" {
    value = [ aws_default_security_group.default.name ]
}

