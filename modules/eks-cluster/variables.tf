
variable "aws_region" {
  type        = string
  description = "AWS Region for resources deployment"
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Project name to identify VPC"
  default     = "prod-techchallenge"
}

variable "cidr_block" {
  type        = string
  description = "IPv4 CIDR block for VPC"
  default     = "10.50.0.0/16"
}

variable "tags" {
  type        = map(any)
  description = "A map of tags to add to all resources."
  default = {
    team    = "Devops"
    project = "prod-techchallenge"
    environment = "Prod"
    managedBy = "Terraform"
  }
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "core-eks"
}


variable "kubernetes_version" {
  description = "Kubernetes version for EKS"
  type        = string
  default     = "1.34"
}

variable "eks_managed_node_groups" {
  description = "Map of EKS managed node groups configuration"
  type        = any
  default = {
    default = {
      instance_types = ["a1.medium"]
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      capacity_type  = "ONDEMAND"
      ami_type       = "AL2_x86_64"
    }
  }
}

variable "eks_access_entries" {
  description = "Map of IAM principals to grant EKS access"
  type        = any
  default     = {}
}