# AWS Details
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-1"
}

# List of variables that the user would need to change

# The name of the existing MSK cluster
variable "mz_msk_cluster_name" {
  description = "The name of the existing MSK cluster"
}

# Port: 9092, or the port that you are using in case it is not 9092 (e.g. 9094 for TLS or 9096 for SASL or 9098 for IAM)
variable "mz_msk_cluster_port" {
  description = "The port of the existing MSK cluster"
}

# The VPC ID of the existing MSK cluster
variable "mz_msk_vpc_id" {
  description = "The VPC ID of the existing MSK cluster"
}

# Endpoint Service Acceptance Required (true/false)
variable "mz_acceptance_required" {
  description = "Endpoint Service Manual Acceptance Required (true/false)"
  default     = false
  type        = bool
}

# Empty list means only same-region access is allowed
# For cross-region access, add the regions to the list
# This will be the regions where your Materialize instance is deployed
variable "mz_supported_regions" {
  description = "The set of regions from which service consumers can access the service"
  type        = list(string)
  default     = []
}
