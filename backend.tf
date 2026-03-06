terraform {
  backend "s3" {
    bucket = "terraform-state-techchallenge"
    key    = "techchallenge3/terraform.tfstate"
    region = var.aws_region
  }
}