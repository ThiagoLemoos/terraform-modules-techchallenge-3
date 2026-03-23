terraform {
  backend "s3" {
    bucket = "testeLucasMorgani"
    key    = "techchallenge3/hml/terraform.tfstate"
    region = "us-east-1"
  }
}
