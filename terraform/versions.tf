terraform {
  required_version = "~> 1.7.0"

  backend "s3" {
    bucket         = "abobotsov-terraform"
    key            = "state/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    dynamodb_table = "tf_lockid"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.33.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
