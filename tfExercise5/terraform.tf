# terraform block, backend, required providers

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" ##Use AWS provider versions >= 5.92.0 and < 6.0.0##

    }
  }
  required_version = ">= 1.0" ##Require Terraform version 1.2 or newer##
}



provider "aws" {
  region = "us-east-2"
}


