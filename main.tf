terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  required_version = ">= 1.12"
}

provider "aws" {
  region  = "ap-southeast-1"
  profile = "Mgod"
}

module "Dev_VPC" {
  source = "./modules/vpc"

  sub_number = 2
}