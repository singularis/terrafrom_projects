provider "aws" {
  region = "eu-north-1"
}

module "vpc" {
  source= "./vpc"
}

module "nodes" {
  source= "./nodes"
  Nodes_instnace_names = ["node1", "node2", "node3"]
  private_ip = ["10.0.0.20", "10.0.0.21", "10.0.0.22"]
  subnet_swarm = module.vpc.subnet_swarm
  sg_allow_swarm_id = module.vpc.sg_allow_swarm_id
  depends_on = [module.vpc]
}

module "getawey" {
  source= "./getawey"
  subnet_swarm = module.vpc.subnet_swarm
  vpc_swarm_var = module.vpc.vpc_swarm
  depends_on = [module.nodes]
}

output "private_ids" {
    value = module.nodes.Nodes_instance_id
}
output "private_ips" {
    value = module.nodes.Nodes_instance_privte_ip
}

output "Getawey_ID" {
    value = module.getawey.Getawey_instance_id
}
output "Getawey_IP" {
    value = module.getawey.Getawey_instance_public_ip
}
