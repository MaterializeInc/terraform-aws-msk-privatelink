terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region                   = var.aws_region
  shared_credentials_files = var.aws_config_file
  profile                  = var.aws_profile
}
