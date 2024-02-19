# Test VPC and MSK Setup for Materialize + PrivateLink Module

This example project demonstrates how to create a test environment with a VPC, subnets, and an Amazon MSK (Managed Streaming for Kafka) cluster, and then use these resources with the Materialize + PrivateLink module.

This setup is intended for testing and development purposes.

## Prerequisites

Before you begin, ensure you have the following prerequisites met:

- Terraform installed on your local machine.
- An AWS account with the necessary permissions to create VPCs, subnets, MSK clusters, and other required resources.
- AWS CLI configured with access credentials.

## Setup Instructions

Follow these steps to deploy the example infrastructure:

1. **Navigate to the Example Directory**

   Change into the `examples/test_vpc_msk_setup` directory where this README is located.

   ```bash
   cd examples/test_vpc_msk_setup
   ```

2. **Initialize Terraform**

   Run the Terraform init command to initialize the project, download providers, and set up the Terraform state.

   ```bash
   terraform init
   ```

3. **Review the Terraform Plan**

   Execute the Terraform plan command to review the resources that will be created.

   ```bash
   terraform plan
   ```

4. **Apply the Terraform Configuration**

   Apply the Terraform configuration to create the resources in AWS.

   ```bash
   terraform apply
   ```

   You'll be prompted to confirm the action before Terraform proceeds with resource creation. Type `yes` when prompted.

   This process will take a few minutes to complete as the MSK cluster creation can take some time.

5. **Access the Resources**

   After Terraform successfully applies the configuration, it will output the IDs of the created VPC, subnets, and the MSK cluster ARN. You can use these outputs to further inspect the resources in the AWS Console or CLI.

6. **Test the MSK + PrivateLink Module**

   After the VPC and the MSK cluster are created, you can use the Materialize + PrivateLink module to create a PrivateLink endpoint for the MSK cluster. Follow the instructions in the module's [README](../../README.md):

    ```hcl
    # Invoke your module here
    module "materialize_privatelink_msk" {
        source = "../../"

        aws_region          = var.aws_region
        mz_msk_cluster_name = aws_msk_cluster.test_msk_cluster.cluster_name
        mz_msk_cluster_port = "9092"
        mz_msk_vpc_id       = aws_vpc.test_vpc.id
    }

    # Output mz_msk_endpoint_sql
    output "mz_msk_endpoint_sql" {
        value = module.materialize_privatelink_msk.mz_msk_endpoint_sql
    }
    ```

## Cleanup

To remove all resources created by this example, run the following command:

```bash
terraform destroy
```

You'll be prompted to confirm the action. Type `yes` to proceed with the deletion of all resources.
