terraform {
  backend "s3" {
    bucket = "terraform-state-techchallenge-equipe7-teste"
    key    = "techchallenge3/hml/terraform.tfstate"
    region = "us-east-1"
  }
}
