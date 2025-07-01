terraform {
  backend "s3" {
    bucket  = "terraformstate1103"
    key     = "prod/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}