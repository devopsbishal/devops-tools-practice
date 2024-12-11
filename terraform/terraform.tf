terraform {
  backend "s3" {
    bucket = "terraform-practice-state-file"
    key = "aws-resource/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "tf-state-locking"
    encrypt = true
  }
}