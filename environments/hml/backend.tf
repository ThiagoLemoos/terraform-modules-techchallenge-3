terraform {
  backend "s3" {
    bucket = "teste-lucas-morgani-techchallenge"
    key    = "techchallenge3/hml/terraform.tfstate"
    region = "us-east-1"
  }
}
