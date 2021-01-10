output "cluster_id" {
  value = local.cluster_id
}

output "subnets" {
  value = module.subnets
}

output "master_ami" {
  value = local.master_ami
}

output "node_ami" {
  value = local.node_ami
}

