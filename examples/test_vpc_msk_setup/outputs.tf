output "test_vpc_id" {
  value       = aws_vpc.test_vpc.id
  description = "The ID of the VPC"
}

output "test_subnet_ids" {
  value       = aws_subnet.test_subnet[*].id
  description = "The IDs of the subnets"
}

output "test_msk_cluster_name" {
  value       = aws_msk_cluster.test_msk_cluster.cluster_name
  description = "The name of the MSK cluster"
}

output "test_msk_bootstrap_brokers" {
  value       = aws_msk_cluster.test_msk_cluster.bootstrap_brokers
  description = "Plaintext connection host:port pairs"
}
