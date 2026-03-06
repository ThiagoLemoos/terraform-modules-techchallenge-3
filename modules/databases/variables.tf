variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default = "us-east-1"
}

variable "tags" {
  description = "Tags for the DocumentDB cluster"
  type        = map(string)
  default = {}
}
