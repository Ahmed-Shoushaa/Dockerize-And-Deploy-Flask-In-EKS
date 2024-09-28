terraform {
  backend "s3" {
    bucket                   = "test-demo-terraform-bucket"
    key                      = "state/eks.tfstate"
    shared_credentials_file  = "./credentials"
    region                   = "us-east-1"
  }
}

provider "aws" {
  region     = "us-east-1"
  shared_credentials_files = ["./credentials"]
}