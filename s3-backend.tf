terraform {
  backend "s3" {
    bucket         = "retrohit-terraform-state"
    key            = "global/s3/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "retrohit-lock-table"
    encrypt        = true
  }
}
