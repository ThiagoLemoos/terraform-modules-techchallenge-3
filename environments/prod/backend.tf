terraform {
  backend "s3" {
    bucket = "teste"
    key    = "techchallenge3/prod/terraform.tfstate"
    region = "us-east-1"
  }
}
