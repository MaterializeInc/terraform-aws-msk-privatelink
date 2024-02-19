output "test_vpc_id" {
  value = aws_vpc.test_vpc.id
}

output "test_subnet_ids" {
  value = aws_subnet.test_subnet[*].id
}

output "test_msk_cluster_arn" {
  value = aws_msk_cluster.test_msk_cluster.arn
}
