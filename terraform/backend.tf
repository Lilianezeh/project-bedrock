terraform {
  backend "s3" {
    bucket  = "project-bedrock-tfstate-304896961232"
    key     = "project-bedrock/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
