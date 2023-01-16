# Get the state of the MSK cluster
data "aws_msk_cluster" "mz_msk_cluster" {
  cluster_name = var.mz_msk_cluster_name
}

# Get the MSK broker nodes using aws_msk_broker_nodes
data "aws_msk_broker_nodes" "mz_msk_broker_nodes" {
  cluster_arn = data.aws_msk_cluster.mz_msk_cluster.arn
}

data "aws_vpc" "mz_msk_vpc" {
  id = var.mz_msk_vpc_id
}
