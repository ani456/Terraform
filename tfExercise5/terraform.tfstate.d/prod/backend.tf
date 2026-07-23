terraform {
  backend "s3" {
    bucket         = "poneglyph-bucket"
    key            = "prod/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "poneglyph-lock"
    encrypt        = true
  }
}
