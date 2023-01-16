# AWS Details
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-1"
}

variable "aws_profile" {
  description = "AWS profile"
  type        = string
  default     = "default"
}
variable "aws_config_file" {
  description = "AWS config file"
  type        = list(any)
  default     = ["~/.aws/config"]
}

# List of variables that the user would need to change

# The name of the existing MSK cluster
variable "mz_msk_cluster_name" {
  description = "The name of the existing MSK cluster"
}

# Port: 9092, or the port that you are using in case it is not 9092 (e.g. 9094 for TLS or 9096 for SASL).
variable "mz_msk_cluster_port" {
  description = "The port of the existing MSK cluster"
}

# The VPC ID of the existing MSK cluster
variable "mz_msk_vpc_id" {
  description = "The VPC ID of the existing MSK cluster"
}

# Subnet IDs of the existing MSK cluster
variable "mz_msk_subnet_ids" {
  description = "Subnet IDs of the existing MSK cluster"
}

# The Availability Zones of the existing MSK cluster
variable "mz_msk_az_ids" {
  description = "The availability zones of the existing MSK cluster"
}
