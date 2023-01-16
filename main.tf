# For each MSK broker, create a target group
resource "aws_lb_target_group" "mz_msk_target_group" {
  count       = length(data.aws_msk_broker_nodes.mz_msk_broker_nodes.node_info_list)
  name        = "mz-msk-target-group-${count.index}"
  port        = var.mz_msk_cluster_port
  protocol    = "TCP"
  vpc_id      = data.aws_vpc.mz_msk_vpc.id
  target_type = "ip"
}

# For each MSK broker, attach a target to the target group
resource "aws_lb_target_group_attachment" "mz_msk_target_group_attachment" {
  count            = length(data.aws_msk_broker_nodes.mz_msk_broker_nodes.node_info_list)
  target_group_arn = aws_lb_target_group.mz_msk_target_group[count.index].arn
  target_id        = data.aws_msk_broker_nodes.mz_msk_broker_nodes.node_info_list[count.index].client_vpc_ip_address
}

# Create a network Load Balancer
resource "aws_lb" "mz_msk_lb" {
  name               = "mz-msk-lb"
  internal           = true
  load_balancer_type = "network"
  subnets            = data.aws_msk_broker_nodes.mz_msk_broker_nodes.node_info_list[*].client_subnet
  tags = {
    Name = "mz-msk-lb"
  }
}

# Create a tcp listener on the Load Balancer for each MSK broker
# with a unique port and forward traffic to the target group
resource "aws_lb_listener" "mz_msk_listener" {
  count             = length(data.aws_msk_broker_nodes.mz_msk_broker_nodes.node_info_list)
  load_balancer_arn = aws_lb.mz_msk_lb.arn
  port              = 9001 + count.index
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mz_msk_target_group[count.index].arn
  }
}

# Create VPC endpoint service for the Load Balancer
resource "aws_vpc_endpoint_service" "mz_msk_lb_endpoint_service" {
  acceptance_required        = true
  network_load_balancer_arns = [aws_lb.mz_msk_lb.arn]
  tags = {
    Name = "mz-msk-lb-endpoint-service"
  }
}

# Return the VPC endpoint service name
output "mz_msk_lb_endpoint_service_name" {
  value = aws_vpc_endpoint_service.mz_msk_lb_endpoint_service.service_name
}
