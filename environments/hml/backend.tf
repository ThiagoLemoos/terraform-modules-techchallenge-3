terraform {
  backend "s3" {
    bucket = "teste"
    key    = "techchallenge3/hml/terraform.tfstate"
    region = "us-east-1"
  }
}
