# List of variables that the user would need to change

# The name of the existing MSK cluster
variable "mz_msk_cluster_name" {
  description = "The name of the existing MSK cluster"
  type        = string
}

# Port: 9092, or the port that you are using in case it is not 9092 (e.g. 9094 for TLS or 9096 for SASL or 9098 for IAM)
variable "mz_msk_cluster_port" {
  description = "The port of the existing MSK cluster"
  type        = string
}

# The VPC ID of the existing MSK cluster
variable "mz_msk_vpc_id" {
  description = "The VPC ID of the existing MSK cluster"
  type        = string
}

# Endpoint Service Acceptance Required (true/false)
variable "mz_acceptance_required" {
  description = "Endpoint Service Manual Acceptance Required (true/false)"
  default     = false
  type        = bool
}

# For cross-region access, add the regions to the list where you want to connect to your MSK cluster from.
# For example, the region where your Materialize environment is deployed.
# Empty list means only same-region access is allowed.
variable "mz_supported_regions" {
  description = "The set of regions that will be allowed to create a privatelink connection to the MSK cluster."
  type        = list(string)
  default     = []
}
