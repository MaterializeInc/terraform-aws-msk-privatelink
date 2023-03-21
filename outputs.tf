# Print the SQL query to create the MSK endpoint in the Materialize:
output "mz_msk_endpoint_sql" {
  value = <<EOF
    -- Create the private link endpoint in Materialize
    CREATE CONNECTION privatelink_svc TO AWS PRIVATELINK (
        SERVICE NAME '${aws_vpc_endpoint_service.mz_msk_lb_endpoint_service.service_name}',
        AVAILABILITY ZONES (${join(", ", [for s in data.aws_subnet.mz_msk_subnet : format("%q", s.availability_zone_id)])})
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
        ${join(",\n", [for broker in data.aws_msk_broker_nodes.mz_msk_broker_nodes.node_info_list : "'${one(broker.endpoints)}:${var.mz_msk_cluster_port}' USING AWS PRIVATELINK privatelink_svc (AVAILABILITY ZONE '${data.aws_subnet.mz_msk_subnet[broker.client_subnet].availability_zone_id}', PORT ${9000 + broker.broker_id})"])}
        ),
        -- Authentication details
        -- Depending on the authentication method the MSK cluster is using
        SASL MECHANISMS = 'SCRAM-SHA-512',
        SASL USERNAME = 'foo',
        SASL PASSWORD = SECRET bar
    );
    EOF
}
