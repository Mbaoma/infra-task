terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
  access_key = "AKIAQLVTWPFBMB2TARVA"
  secret_key = "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"
}
