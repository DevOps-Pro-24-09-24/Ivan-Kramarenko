
terraform {
  backend "s3" {
    bucket         = "hw-6"
    key            = "hw6/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "hw6"
    encrypt        = true
  }
}
