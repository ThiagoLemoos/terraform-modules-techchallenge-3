terraform {
  backend "s3" {
    bucket = "testeLucasMorgani"
    key    = "techchallenge3/prod/terraform.tfstate"
    region = "us-east-1"
  }
}
