terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.39"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  profile = "default"
}

