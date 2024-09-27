terraform {
  backend "s3" {
    bucket                  = "test-demo-terraform-bucket"
    key                     = "state/eks.tfstate"
    region                  = var.aws_region
    access_key              = var.aws_access_key
    secret_key              = var.aws_secret_key
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}