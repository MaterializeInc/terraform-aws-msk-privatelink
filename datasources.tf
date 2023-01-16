# Get the state of the MSK cluster
data "aws_msk_cluster" "mz_msk_cluster" {
  cluster_name = var.mz_msk_cluster_name
}

# Get the MSK broker nodes using aws_msk_broker_nodes
data "aws_msk_broker_nodes" "mz_msk_broker_nodes" {
  cluster_arn = data.aws_msk_cluster.mz_msk_cluster.arn
}

# Get the VPC details using aws_vpc
data "aws_vpc" "mz_msk_vpc" {
  id = var.mz_msk_vpc_id
}

data "aws_subnet" "mz_msk_subnet" {
  for_each = toset(data.aws_msk_broker_nodes.mz_msk_broker_nodes.node_info_list[*].client_subnet)
  id       = each.value
}
