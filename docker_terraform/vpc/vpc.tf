resource "aws_vpc" "swarm" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_hostnames = true
    tags = {
        "Name" = "SwarmVPC"
    }
}

resource "aws_internet_gateway" "swarm_gw" {
    vpc_id = aws_vpc.swarm.id
    tags = {
        "Name" = "SwarmGW"
    }
    depends_on = [aws_vpc.swarm]
}

resource "aws_subnet" "swarm_subnet" {
    vpc_id                  = aws_vpc.swarm.id
    cidr_block              = "10.0.0.0/24"
    map_public_ip_on_launch = true
    depends_on = [aws_internet_gateway.swarm_gw]
    tags = {
        "Name" = "SwarmSubnet"
    }
}

module "sg" {
    source = "../sg"
    vpc_swarm_var = aws_vpc.swarm.id
}

output "subnet_swarm" {
    value = aws_subnet.swarm_subnet.id
    }

output "vpc_swarm" {
    value = aws_vpc.swarm.id
}

output "sg_allow_swarm_id" {
    value = module.sg.sg_allow_swarm_id 
}

resource "aws_route_table" "swarm" {
  vpc_id = aws_vpc.swarm.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.swarm_gw.id
  }
  tags = {
    Name = "Swarm_Route"
  }
  depends_on = [aws_internet_gateway.swarm_gw]
}

resource "aws_main_route_table_association" "a" {
  vpc_id         = aws_vpc.swarm.id
  route_table_id = aws_route_table.swarm.id
  depends_on = [aws_route_table.swarm]  
}