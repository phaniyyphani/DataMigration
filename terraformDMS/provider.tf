terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Configuring aws provider using shared creds file
provider "aws" {
  shared_credentials_files = ["./.aws/credentials.txt"]
  profile                  = "phaniaccesskeys"
  region                   = "us-east-1"
}