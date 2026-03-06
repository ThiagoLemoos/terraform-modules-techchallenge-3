# variables example:

variable "aws_region" {
  type        = string
  description = "AWS Region for resources deployment"
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Project name to identify VPC"
  default     = "techchallenge"
}

variable "cidr_block" {
  type        = string
  description = "IPv4 CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "tags" {
  type        = map(any)
  description = "A map of tags to add to all resources."
  default = {
    team    = "Devops"
    project = "env-techchallenge"
    environment = "Prod"
    managedBy = "Terraform"
  }
}