# Contributor Instructions

## Testing

### Manual Testing

There are two ways to test the module manually:

#### Option 1: Using an Existing Amazon MSK Cluster

1. Login to the [AWS console](https://aws.amazon.com/).
2. Manually create an [Amazon MSK cluster](https://docs.aws.amazon.com/msk/latest/developerguide/msk-create-cluster.html) if you don't already have one.
3. Copy the `terraform.tfvars.example` file to `terraform.tfvars`:
    ```
    cp terraform.tfvars.example terraform.tfvars
    ```
4. Update the values in `terraform.tfvars` to match your cluster.
5. Create the resources:
    ```
    terraform apply
    ```
6. After the resources have been created, go to the Target Groups in the AWS console and ensure that the health checks are passing. If they are not, you may need to add the subnet CIDR blocks of your MSK cluster to the security groups of your MSK cluster. For more information, see [this AWS documentation](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-troubleshooting.html).
7. Next, run the queries in the output to create the connection in Materialize.
8. In your AWS console, under the Endpoint Service that was created, approve the connection request from the Materialize instance and check that the connection is active.
9. You can now create a Kafka source in Materialize using the connection name from the output.
10. Finally, drop the connection in Materialize and run `terraform destroy` to clean up the resources.

#### Option 2: Automatically Creating a New VPC and MSK Cluster

1. Navigate to the `examples/test_vpc_msk_setup` directory within the module repository.
2. Follow the README.md instructions in that directory to deploy the example project. This will automatically create a new VPC and Amazon MSK cluster suitable for testing.
3. After deployment, proceed with steps 6 to 10 from Option 1 to test the module functionality.

## Cutting a New Release

To prepare a new release:

1. Perform a manual test of the latest code on `main`, using one of the manual testing options detailed above.
2. Tag the release and push the tag to the repository:
    ```
    git tag -a vX.Y.Z -m vX.Y.Z
    git push origin vX.Y.Z
    ```
