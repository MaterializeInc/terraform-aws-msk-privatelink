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
  subnets            = var.mz_msk_subnet_ids
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

# Print the SQL query to create the MSK endpoint in the Materialize:
output "mz_msk_endpoint_sql" {
  value = <<EOF
    -- Create the private link endpoint in Materialize
    CREATE CONNECTION privatelink_svc TO AWS PRIVATELINK (
        SERVICE NAME '${aws_vpc_endpoint_service.mz_msk_lb_endpoint_service.service_name}',
        AVAILABILITY ZONES (${join(", ", [for s in var.mz_msk_az_ids : format("%q", s)])})
    );

    -- Get the allowed principals for the VPC endpoint service
    SELECT principal
    FROM mz_aws_privatelink_connections plc
    JOIN mz_connections c ON plc.id = c.id
    WHERE c.name = 'privatelink_svc';

    -- IMPORTANT: Get the allowed principals, then add them to the VPC endpoint service

    -- Create the connection to the MSK cluster
    CREATE CONNECTION kafka_connection TO KAFKA (
        BROKERS (
        ${join(",\n", [for broker in data.aws_msk_broker_nodes.mz_msk_broker_nodes.node_info_list : "'${one(broker.endpoints)}:${var.mz_msk_cluster_port}' USING AWS PRIVATELINK privatelink_svc (PORT ${9000 + broker.broker_id})"])}
        ),
        -- Authentication details
        -- Depending on the authentication method the MSK cluster is using
        SASL MECHANISMS = 'SCRAM-SHA-512',
        USERNAME = 'foo',
        PASSWORD = SECRET bar
    );
    EOF
}
